use mlua::prelude::*;

// use common::clue::{fun, noop};

pub fn disable<'a>(lua: &'a Lua, s: &str) -> LuaResult<LuaTable<'a>> {
    Ok(common::tbl! { lua;
        1, s,
        "enabled", false,
    })
}

pub fn stdpaths_cache() -> String {
    let cache_home = std::env::var("XDG_CACHE_HOME");
    if let Ok(cache_home) = cache_home {
        cache_home
    } else {
        format!("{}/{}", env!("HOME"), ".cache")
    }
}

pub fn default(lua: &'static Lua) -> LuaResult<LuaTable> {
    macro_rules! tbl {
        ( $( $k:expr, $v:expr, )* ) => {
            common::tbl![lua; $($k, $v,)*]
        }
    }

    macro_rules! list {
        ( $( $v:expr, )* ) => {
            common::list![lua; $($v,)*]
        }
    }

    let opts = tbl! {
        "spec", list! {
            tbl! {
                1, "LazyVim/LazyVim",
                "import", "lazyvim.plugins",
                "opts", tbl! {
                    "colorscheme", "tokyonight",
                },
            },
        },
    };

    Ok(opts)
}
