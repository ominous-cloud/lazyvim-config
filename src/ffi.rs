use std::ffi::c_char;

extern "C" {
    // https://github.com/neovim/neovim/blob/7bf1a917b78ebc622b6691af9196b95b4a9d3142/src/nvim/os/stdpaths.c#L172
    pub fn stdpaths_user_data_subpath(fname: *const c_char) -> *const c_char;

    // https://github.com/neovim/neovim/blob/7bf1a917b78ebc622b6691af9196b95b4a9d3142/src/nvim/os/fs.c#L140
    pub fn os_isdir(name: *const c_char) -> bool;
}
