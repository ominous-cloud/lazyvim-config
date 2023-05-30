pub mod plugins;

use mlua::prelude::*;
use std::process::Command;

#[mlua::lua_module]
pub fn init(lua: &'static Lua) -> LuaResult<LuaValue> {
    let url = common::api::stdpaths_user_data_subpath("lazy/lazy.nvim")
        .expect("unable to get std data path");
    let path = std::path::Path::new(&url);

    if !path.is_dir() {
        Command::new("git")
            .args([
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable",
                &url,
            ])
            .output()
            .expect("unable to clone lazy.nvim");
    }

    common::api::prepend("runtimepath", url).expect("unable to modify runtime path");

    lua.globals()
        .get::<_, LuaFunction>("require")?
        .call::<_, LuaTable>("lazy")?
        .get::<_, LuaFunction>("setup")?
        .call::<_, ()>(plugins::default(lua)?)?;

    Ok(LuaNil)
}
