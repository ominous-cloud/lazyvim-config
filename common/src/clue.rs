use mlua::prelude::*;

pub fn fun(lua: &Lua, chunk: String) -> LuaResult<LuaFunction> {
    lua.create_function(move |lua, _: ()| {
        lua.load(&chunk).exec()?;
        Ok(())
    })
}

pub fn noop(lua: &Lua) -> LuaResult<LuaFunction> {
    lua.create_function(|_, _: ()| Ok(()))
}


pub fn inspect<'a, T: ToLua<'a>>(lua: &'a Lua, opts: T) -> LuaResult<()> {
    let print = lua.globals().get::<_, LuaFunction>("print")?;
    let inspect = lua
        .globals()
        .get::<_, LuaTable>("vim")?
        .get::<_, LuaTable>("inspect")?;
    let opts = inspect.call::<_, LuaString>(opts);
    print.call::<_, ()>(opts)?;
    Ok(())
}
