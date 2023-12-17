use crate::oxi::{self, api};

macro_rules! opt {
    ($($key:ident: $value:expr),*$(,)?) => {
        let opts =crate::oxi::api::opts::OptionValueOpts::default();
        $(
            crate::oxi::api::set_option_value( stringify!($key), $value, &opts)?;
        )*
    };
}

fn append(key: &str, value: &str) -> oxi::Result<()> {
    let opts = api::opts::OptionValueOpts::default();
    let current_value: String = api::get_option_value(key, &opts)?;
    let new_value = format!("{}{}", current_value, value);
    api::set_option_value(key, new_value, &opts)?;
    Ok(())
}

fn remove(key: &str, value: &str) -> oxi::Result<()> {
    let opts = api::opts::OptionValueOpts::default();
    let current_value: String = api::get_option_value(key, &opts)?;
    let new_value = current_value
        .split(",")
        .filter(|&x| x != value)
        .collect::<Vec<_>>()
        .join(",");
    api::set_option_value(key, new_value, &opts)?;
    Ok(())
}

pub(crate) fn setup() -> oxi::Result<()> {
    opt! {
        autoread: true,
        belloff: "all",
        fillchars: "eob: ,fold: ,vert: ",
        background: "dark",
        showcmd: false,
        ruler: false,
        showtabline: 0,
        clipboard: "unnamed",
        cindent: true,
        scrolloff: 5,
        showmode: false,
        termguicolors: true,
        laststatus: 0,
        undofile: true,
        smoothscroll: true,
    };
    append("shortmess", "cSI")?;
    remove("cinkeys", "0#")?;
    remove("indentkeys", "0#")?;

    // api::command("color quiet")?;
    // api::command("color default")?;
    let transparent = api::opts::SetHighlightOpts::builder()
        .background("none")
        .build();
    let unbold = api::opts::SetHighlightOpts::builder().bold(false).build();
    api::set_hl(0, "Normal", &transparent)?;
    api::set_hl(0, "StatusLine", &transparent)?;
    api::set_hl(0, "Keyword", &unbold)?;

    Ok(())
}
