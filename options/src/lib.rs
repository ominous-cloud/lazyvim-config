use mlua::prelude::*;

macro_rules! opt {
    ( $k:expr, $v:expr ) => {
        common::api::set_option($k, $v).expect("unable to set option");
    };
}

#[mlua::lua_module]
fn config_options(_: &Lua) -> LuaResult<LuaValue> {
    opt!("number", false);
    opt!("relativenumber", false);
    opt!("signcolumn", "yes");
    opt!("cursorline", false);
    opt!("ruler", false);
    opt!("wrap", true);

    opt!("ignorecase", false);
    opt!("completeopt", "menu,preview");

    opt!("shiftwidth", 4);
    opt!("tabstop", 8);

    opt!("autowrite", false);
    opt!("confirm", false);

    Ok(LuaNil)
}
