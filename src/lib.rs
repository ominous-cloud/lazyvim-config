mod ffi;
mod macros;
mod nvim;

use macros::tbl;
use mlua::{Function as LuaFunction, Table as LuaTable};
use nvim_oxi as oxi;
use std::ffi::{CStr, CString};
use std::process::Command;

pub fn setup_lazy() -> oxi::Result<()> {
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

pub fn load_plugins() -> oxi::Result<()> {
    let lua = oxi::mlua::lua();
    lua.globals()
        .get::<_, LuaFunction>("require")?
        .call::<_, LuaTable>("lazy")?
        .get::<_, LuaFunction>("setup")?
        .call::<_, ()>(tbl! {
            "spec", tbl! {
                1, tbl! {
                    "url", "https://github.com/LazyVim/LazyVim.git",
                    "import", "lazyvim.plugins",
                },
            },
        })?;
    Ok(())
}

#[oxi::module]
pub fn init() -> oxi::Result<()> {
    setup_lazy()?;
    load_plugins()?;
    Ok(())
}
