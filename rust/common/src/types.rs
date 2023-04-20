use core::{ffi, slice};
use std::borrow::Cow;
use std::ffi::{c_char, c_double, c_int};
use std::mem::ManuallyDrop;
use std::string::String as StdString;
use std::{mem, ptr};

#[repr(C)]
pub struct Object {
    pub ty: ObjectKind,
    pub data: ObjectData,
}

#[repr(C)]
pub enum ObjectKind {
    Nil = 0,
    Boolean,
    Integer,
    Float,
    String,
    Array,
    Dictionary,
    LuaRef,
    Buffer,
    Window,
    TabPage,
}

type Boolean = bool;
type Integer = i64;
type Float = c_double;
type LuaRef = c_int;

#[repr(C)]
pub union ObjectData {
    boolean: Boolean,
    integer: Integer,
    float: Float,
    string: ManuallyDrop<String>,
    array: ManuallyDrop<Array>,
    dictionary: ManuallyDrop<Dictionary>,
    luaref: LuaRef,
}

impl Default for Object {
    fn default() -> Object {
        Object::nil()
    }
}

impl Object {
    pub fn nil() -> Self {
        Self {
            ty: ObjectKind::Nil,
            data: ObjectData { integer: 0 },
        }
    }

    pub unsafe fn into_string(self) -> String {
        let s = String {
            ..*self.data.string
        };
        core::mem::forget(self);
        s
    }
}

impl From<StdString> for Object {
    fn from(value: StdString) -> Self {
        Self {
            ty: ObjectKind::String,
            data: ObjectData {
                string: ManuallyDrop::new(String::from(value.as_str())),
            },
        }
    }
}

impl From<&str> for Object {
    fn from(value: &str) -> Self {
        Self {
            ty: ObjectKind::String,
            data: ObjectData {
                string: ManuallyDrop::new(String::from(value)),
            },
        }
    }
}

impl From<bool> for Object {
    fn from(value: bool) -> Self {
        Self {
            ty: ObjectKind::Boolean,
            data: ObjectData { boolean: value },
        }
    }
}

impl Drop for Object {
    fn drop(&mut self) {
        match self.ty {
            ObjectKind::String => unsafe { ManuallyDrop::drop(&mut self.data.string) },

            ObjectKind::Array => unsafe { ManuallyDrop::drop(&mut self.data.array) },

            ObjectKind::Dictionary => unsafe { ManuallyDrop::drop(&mut self.data.dictionary) },

            _ => {}
        }
    }
}

#[repr(C)]
pub struct String {
    pub data: *mut ffi::c_char,
    pub size: usize,
}

impl String {
    pub fn as_bytes(&self) -> &[u8] {
        if self.data.is_null() {
            &[]
        } else {
            assert!(self.size <= isize::MAX as usize);
            unsafe { slice::from_raw_parts(self.data as *const u8, self.size) }
        }
    }

    pub fn as_ptr(&self) -> *const ffi::c_char {
        self.data as _
    }

    pub fn from_bytes(bytes: &[u8]) -> Self {
        let data = unsafe {
            let data = libc::malloc(bytes.len() + 1) as *mut ffi::c_char;
            libc::memcpy(data as *mut _, bytes.as_ptr() as *const _, bytes.len());
            *data.add(bytes.len()) = 0;
            data
        };

        Self {
            data: data as *mut _,
            size: bytes.len(),
        }
    }

    pub fn new() -> Self {
        Self {
            data: core::ptr::null_mut(),
            size: 0,
        }
    }

    pub fn to_string_lossy(&self) -> Cow<'_, str> {
        std::string::String::from_utf8_lossy(self.as_bytes())
    }
}

impl Drop for String {
    fn drop(&mut self) {
        // TODO
    }
}

impl From<&str> for String {
    #[inline]
    fn from(s: &str) -> Self {
        Self::from_bytes(s.as_bytes())
    }
}

#[repr(C)]
pub struct Error {
    r#type: ErrorType,
    msg: *mut c_char,
}

unsafe impl Send for Error {}
unsafe impl Sync for Error {}

#[repr(C)]
enum ErrorType {
    None = -1,
    // Exception,
    // Validation,
}

impl Error {
    pub const fn new() -> Self {
        Self {
            r#type: ErrorType::None,
            msg: std::ptr::null_mut(),
        }
    }
}

impl Default for Error {
    fn default() -> Self {
        Self::new()
    }
}

#[repr(C)]
pub struct KVec<T> {
    pub size: usize,
    pub capacity: usize,
    pub items: *mut T,
}

impl<T> KVec<T> {
    pub fn new() -> Self {
        Self {
            items: core::ptr::null_mut(),
            size: 0,
            capacity: 0,
        }
    }

    pub fn with_capacity(capacity: usize) -> Self {
        let items = unsafe { libc::malloc(capacity * mem::size_of::<T>()) as *mut T };

        Self {
            items,
            size: 0,
            capacity,
        }
    }

    pub fn push(&mut self, item: T) {
        if self.capacity == 0 {
            self.capacity = 4;
            self.items = unsafe { libc::malloc(self.capacity * mem::size_of::<T>()) as *mut T };
        } else if self.size == self.capacity {
            self.capacity *= 2;

            assert!(self.capacity * mem::size_of::<T>() <= isize::MAX as usize);

            self.items = unsafe {
                libc::realloc(
                    self.items as *mut libc::c_void,
                    self.capacity * mem::size_of::<T>(),
                ) as *mut T
            };
        }

        unsafe {
            ptr::write(self.items.add(self.size), item);
        }

        self.size += 1;
    }
}

#[repr(C)]
pub struct KeyValuePair {
    key: String,
    value: Object,
}

#[repr(transparent)]
pub struct Dictionary(pub KVec<KeyValuePair>);

#[repr(transparent)]
pub struct Array(pub KVec<Object>);
