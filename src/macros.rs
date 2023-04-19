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

macro_rules! list {
    ( $( $v:expr, )* ) => {
        {
            let lua = nvim_oxi::mlua::lua();
            let table = lua.create_table()?;
            let i = 0;
            $(
                let i = i + 1;
                table.set(i, $v)?;
            )*
            table
        }
    };
}

pub(crate) use list;
pub(crate) use tbl;
