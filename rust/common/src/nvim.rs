use crate::types::Object;

#[repr(C)]
#[derive(Default)]
pub struct KeyDict_option {
    scope: Object,
    win: Object,
    buf: Object,
    filetype: Object,
}