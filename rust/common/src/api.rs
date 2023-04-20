use std::ffi::{CStr, CString};

use crate::{ffi, nvim, types};

pub fn stdpaths_user_data_subpath(fname: &str) -> Result<String, Box<dyn std::error::Error>> {
    let name = CString::new(fname).expect("unable to create cstr");
    let path = unsafe { CStr::from_ptr(ffi::stdpaths_user_data_subpath(name.as_ptr())) };
    Ok(String::from_utf8_lossy(path.to_bytes()).to_string())
}

pub fn get_option(opt: &str) -> Result<String, Box<dyn std::error::Error>> {
    let name = From::from(opt);
    let opts = nvim::KeyDict_option::default();
    let mut err = types::Error::default();
    let res = unsafe { ffi::nvim_get_option_value(name, &opts, &mut err) };
    match res.ty {
        types::ObjectKind::String => {
            let res = res.into_string();
            let res = res.to_string_lossy();
            Ok(res.to_string())
        }
        _ => Err("option type is not string")?,
    }
}

pub fn set_option<T>(opt: &str, value: T) -> Result<(), Box<dyn std::error::Error>>
where
    T: Into<types::Object>,
{
    let name = From::from(opt);
    let opts = nvim::KeyDict_option::default();
    let value = value.into();
    let mut err = types::Error::default();
    unsafe { ffi::nvim_set_option_value(0, name, value, &opts, &mut err) };
    Ok(())
}

pub fn prepend(opt: &str, value: String) -> Result<(), Box<dyn std::error::Error>> {
    let list = get_option(opt)?;
    set_option(opt, format!("{},{}", list, value))?;
    Ok(())
}

pub fn keymap(mode: &str, lhs: &str, rhs: &str) -> Result<(), Box<dyn std::error::Error>> {
    let mode = mode.into();
    let lhs = lhs.into();
    let rhs = rhs.into();
    let opts = nvim::KeyDict_keymap::new();
    let mut err = types::Error::default();
    unsafe {
        ffi::nvim_set_keymap(0, mode, lhs, rhs, &opts, &mut err);
    }
    Ok(())
}
