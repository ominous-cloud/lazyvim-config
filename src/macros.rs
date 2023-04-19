macro_rules! tbl {
    ( $( $k:expr, $v:expr, )* ) => {
        {
            let lua = nvim_oxi::mlua::lua();
            let table = lua.create_table()?;
            $(
                table.set($k, $v)?;
            )*
            table
        }
    };
}

pub(crate) use tbl;
