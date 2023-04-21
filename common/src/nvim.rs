use crate::types::Object;

#[repr(C)]
#[derive(Default)]
pub struct KeyDict_option {
    scope: Object,
    win: Object,
    buf: Object,
    filetype: Object,
}

#[repr(C)]
#[derive(Default)]
pub struct KeyDict_keymap {
    nowait: Object,
    silent: Object,
    script: Object,
    expr: Object,
    unique: Object,
    noremap: Object,
    desc: Object,
    callback: Object,
    replace_keycodes: Object,
}

impl KeyDict_keymap {
    pub fn new() -> Self {
        Self {
            noremap: true.into(),
            silent: true.into(),
            ..Default::default()
        }
    }
}
