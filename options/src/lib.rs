use mlua::prelude::*;

macro_rules! opt {
    ( $k:expr, $v:expr ) => {
        common::api::set_option($k, $v).expect("unable to set option");
    };
}

#[mlua::lua_module]
fn config_options(_: &Lua) -> LuaResult<LuaValue> {
    Ok(LuaNil)
}
