use std::{
    ffi::{CStr, CString},
    process::Command,
};

use nvim_oxi as oxi;

use crate::{ffi, nvim};

pub fn setup() -> oxi::Result<()> {
    let lazy = CString::new("lazy/lazy.nvim").expect("unable to create cstr");
    let (path, present) = unsafe {
        let path = CStr::from_ptr(ffi::stdpaths_user_data_subpath(lazy.as_ptr()));
        let present = ffi::os_isdir(path.as_ptr());
        (path, present)
    };
    let path = String::from_utf8_lossy(path.to_bytes()).to_string();
    if !present {
        oxi::print!("getting lazy.nvim");
        Command::new("git")
            .args([
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable",
                &path,
            ])
            .output()
            .expect("unable to clone lazy.nvim");
        oxi::print!("lazy.nvim cloned!");
    }

    nvim::prepend("rtp", path)?;

    Ok(())
}
