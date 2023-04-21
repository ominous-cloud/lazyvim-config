#[macro_export]
macro_rules! tbl {
    ( $lua:ident; $( $k:expr, $v:expr, )* ) => {
        {
            let table = $lua.create_table()?;
            $(
                table.set($k, $v)?;
            )*
            table
        }
    };
}

#[macro_export]
macro_rules! list {
    ( $lua:ident; $( $v:expr, )* ) => {
        {
            let table = $lua.create_table()?;
            let i = 0;
            $(
                let i = i + 1;
                table.set(i, $v)?;
            )*
            table
        }
    };
}
