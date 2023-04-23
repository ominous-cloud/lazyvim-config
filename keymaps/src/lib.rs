use mlua::prelude::*;

macro_rules! map {
    ( $mode:expr, $lhs:expr, $rhs:expr ) => {
        common::api::keymap($mode, $lhs, $rhs).expect("unable to set keymap");
    };
}

#[mlua::lua_module]
fn config_keymaps(_: &Lua) -> LuaResult<LuaValue> {
    Ok(LuaNil)
}
