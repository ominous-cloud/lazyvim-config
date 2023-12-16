use crate::oxi::{self, api};

macro_rules! g {
    ($($key:ident => $value:expr),*$(,)?) => {
        $(
            crate::oxi::api::set_option(stringify!($key), $value)?;
        )*
    };
}

fn append(key: & str, value: &str) -> oxi::Result<()> {
    let current_value: String = api::get_option(key)?;
    let new_value =  format!("{}{}", current_value, value);
    api::set_option(key, new_value)?;
    Ok(())
}

pub(crate) fn setup() -> oxi::Result<()> {
    g! {
        autoread => true,
        belloff => "all",
        fillchars => "eob: ,fold: ,vert: ",
        background => "dark",
        showcmd => false,
        ruler => false,
        showtabline => 0,
        clipboard => "unnamed",
        undofile => true,
        cindent => true,
        scrolloff => 5,
        showmode => false,
        smoothscroll => true,
        termguicolors => true,
        laststatus => 0,
    }

    append("shortmess", "cSI")?;

    api::command("color default")?;
    // api::command("color quiet")?;
    let transparent = api::opts::SetHighlightOpts::builder()
        .background("none")
        .build();
    let unbold = api::opts::SetHighlightOpts::builder().bold(false).build();
    api::set_hl(0, "Normal", &transparent)?;
    api::set_hl(0, "StatusLine", &transparent)?;
    api::set_hl(0, "Keyword", &unbold)?;

    Ok(())
}
