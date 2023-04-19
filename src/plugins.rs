use mlua::{Function as LuaFunction, Table as LuaTable};
use nvim_oxi as oxi;

use crate::macros::{list, tbl};

pub fn setup() -> oxi::Result<()> {
    let lua = oxi::mlua::lua();
    let opts = tbl! {
        "spec", list! {
            tbl! {
                1, "https://github.com/LazyVim/LazyVim.git",
                "import", "lazyvim.plugins",
            },
            // override default config
            tbl! {
                1, "folke/neodev.nvim",
                "enabled", false,
            },
            tbl! {
                1, "folke/tokyonight.nvim",
                "opts", tbl! {
                    "transparent", true,
                    "styles", tbl! {
                        "sidebars", "transparent",
                        "floats", "transparent",
                    },
                },
            },
            tbl! {
                1, "williamboman/mason.nvim",
                "opts", lua.create_function(|_, (_, opts): (LuaTable, LuaTable)| {
                    opts.set("ensure_installed", tbl!())?;
                    Ok(())
                })?,
            },
            tbl! {
                1, "neovim/nvim-lspconfig",
                "opts", tbl! {
                    "servers", tbl! {
                        "jsonls", tbl! {
                            "mason", false,
                        },
                        "lua_ls", tbl! {
                            "mason", false,
                        },
                        "rust_analyzer", tbl! {
                            "mason", false,
                        },
                    },
                },
            },
        },
    };
    lua.globals()
        .get::<_, LuaFunction>("require")?
        .call::<_, LuaTable>("lazy")?
        .get::<_, LuaFunction>("setup")?
        .call::<_, ()>(opts)?;
    Ok(())
}
