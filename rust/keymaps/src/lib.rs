use mlua::prelude::*;

#[mlua::lua_module]
fn config_keymaps(_: &Lua) -> LuaResult<LuaValue> {
    Ok(LuaNil)
}
