use mlua::{Function as LuaFunction, Table as LuaTable};
use nvim_oxi as oxi;

use crate::macros::{list, tbl};

pub fn disable(s: &str) -> oxi::Result<LuaTable> {
    Ok(tbl! {
        1, s,
        "enabled", false,
    })
}

pub fn setup() -> oxi::Result<()> {
    let lua = oxi::mlua::lua();
    let opts = tbl! {
        "spec", list! {
            tbl! {
                1, "LazyVim/LazyVim",
                "import", "lazyvim.plugins",
                "opts", tbl! {
                    "colorscheme", "tokyonight",
                },
            },
            // override default config
            disable("folke/neodev.nvim")?,
            // disable("ggandor/leap.nvim")?,
            disable("nvim-treesitter/nvim-treesitter")?,
            disable("nvim-treesitter/nvim-treesitter-textobjects")?,
            disable("folke/todo-comments.nvim")?,
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
                1, "rcarriga/nvim-notify",
                "opts", tbl! {
                    "background_colour", "#000000",
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
                    "autoformat", false,
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
