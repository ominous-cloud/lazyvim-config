use std::ffi::c_char;

use crate::nvim;
use crate::types;

extern "C" {
    // https://github.com/neovim/neovim/blob/v0.9.0/src/nvim/os/stdpaths.c#L172
    pub fn stdpaths_user_data_subpath(fname: *const c_char) -> *const c_char;

    pub fn nvim_get_option_value(
        name: types::String,
        opts: *const nvim::KeyDict_option,
        err: *mut types::Error,
    ) -> types::Object;

    pub fn nvim_set_option_value(
        channel_id: u64,
        name: types::String,
        value: types::Object,
        opts: *const nvim::KeyDict_option,
        err: *mut types::Error,
    );
}
