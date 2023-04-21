use mlua::prelude::*;

macro_rules! map {
    ( $mode:expr, $lhs:expr, $rhs:expr ) => {
        common::api::keymap($mode, $lhs, $rhs).expect("unable to set keymap");
    };
}

#[mlua::lua_module]
fn config_keymaps(_: &Lua) -> LuaResult<LuaValue> {
    map!("n", "<space>fh", "\":bp<cr>\"");
    map!("n", "<space>fl", "\":bn<cr>\"");
    map!("n", "<space>ff", "\":e#<cr>\"");
    map!("n", "<space>fd", "\":bd<cr>\"");
    map!("c", "<c-a>", "\"<c-b>\"");

    Ok(LuaNil)
}
