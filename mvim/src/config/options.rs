use crate::oxi::{self, api};

enum Operation {
    Append,
    Remove,
}

fn update_value(key: &str, value: &str, operation: Operation) -> oxi::Result<()> {
    let opts = Default::default();
    let current_value: String = api::get_option_value(key, &opts)?;
    let new_value = match operation {
        Operation::Append => format!("{}{}", current_value, value),
        Operation::Remove => current_value
            .split(",")
            .filter(|&x| x != value)
            .collect::<Vec<_>>()
            .join(","),
    };
    api::set_option_value(key, new_value, &opts)?;
    Ok(())
}

pub(crate) fn setup() -> oxi::Result<()> {
    macro_rules! opt {
        ($($key:ident: $value:literal $(to $op:ident)?),*$(,)?) => {
            $(
                opt!(impl $key: $value $(to $op)?);
            )*
        };
        (impl $key:ident: $value:literal) => {
            crate::oxi::api::set_option_value(stringify!($key), $value, &Default::default())?;
        };
        (impl $key:ident: $value:literal to append) => {
            update_value(stringify!($key), $value, Operation::Append)?;
        };
        (impl $key:ident: $value:literal to remove) => {
            update_value(stringify!($key), $value, Operation::Remove)?;
        };
    }

    opt! {
        fillchars: "eob: ,fold: ,vert: ",
        showcmd: false,
        ruler: false,
        showtabline: 0,
        signcolumn: "no",
        clipboard: "unnamed",
        cindent: true,
        scrolloff: 5,
        showmode: false,
        termguicolors: true,
        laststatus: 0,
        undofile: true,
        smoothscroll: true,
        shortmess: "cSI" to append,
        cinkeys: "0#" to remove,
        indentkeys: "0#" to remove,
    }

    // api::command("color quiet")?;
    // api::command("color default")?;
    let transparent = api::opts::SetHighlightOpts::builder()
        .background("none")
        .build();
    // let unbold = api::opts::SetHighlightOpts::builder().bold(false).build();
    api::set_hl(0, "Normal", &transparent)?;
    api::set_hl(0, "StatusLine", &transparent)?;
    // api::set_hl(0, "Keyword", &unbold)?;

    Ok(())
}
