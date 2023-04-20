use mlua::prelude::*;

pub fn disable<'a>(lua: &'a Lua, s: &str) -> LuaResult<LuaTable<'a>> {
    Ok(common::tbl! { lua;
        1, s,
        "enabled", false,
    })
}

pub fn fun(lua: &Lua, chunk: String) -> LuaResult<LuaFunction> {
    lua.create_function(move |lua, _: ()| {
        lua.load(&chunk).exec()?;
        Ok(())
    })
}

pub fn default(lua: &'static Lua) -> LuaResult<LuaTable> {
    macro_rules! tbl {
        ( $( $k:expr, $v:expr, )* ) => {
            common::tbl![lua; $($k, $v, )*]
        }
    }

    macro_rules! list {
        ( $( $v:expr, )* ) => {
            common::list![lua; $($v, )*]
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
            // override default config
            disable(lua, "folke/neodev.nvim")?,
            disable(lua, "ggandor/leap.nvim")?,
            disable(lua, "ggandor/flit.nvim")?,
            disable(lua, "nvim-treesitter/nvim-treesitter")?,
            disable(lua, "nvim-treesitter/nvim-treesitter-textobjects")?,
            disable(lua, "folke/todo-comments.nvim")?,
            disable(lua, "echasnovski/mini.pairs")?,
            disable(lua, "echasnovski/mini.bufremove")?,
            //  disable(lua, "lewis6991/gitsigns.nvim")?,
            disable(lua, "akinsho/bufferline.nvim")?,
            disable(lua, "nvim-lualine/lualine.nvim")?,
            // disable(lua, "lukas-reineke/indent-blankline.nvim")?,
            // disable(lua, "echasnovski/mini.indentscope")?,
            disable(lua, "echasnovski/mini.ai")?,
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
                1, "folke/noice.nvim",
                "opts", tbl! {
                    "presets", tbl! {
                        "command_palette", false,
                    },
                    "cmdline", tbl! {
                        "enable", true,
                        "view", "cmdline",
                    },
                    "messages", tbl! {
                        "enable", true,
                        "view", "mini",
                        "view_error", "mini",
                        "view_warn", "mini",
                    },
                    "lsp", tbl! {
                        "progress", tbl! {
                            "enable", false,
                            "view", "mini",
                        },
                        "signature", tbl! {
                            "auto_open", tbl! {
                                "enabled", false,
                            },
                        },
                    },
                },
            },
            tbl! {
                1, "goolord/alpha-nvim",
                "config", fun(lua, r#"
                    local config = require("alpha.themes.startify").config
                    config.layout[2].val = "しゃがみガード"
                    require("alpha").setup(config)
                "#.to_string())?,
            },
            tbl! {
                1, "nvim-neo-tree/neo-tree.nvim",
                "keys", list! {
                    list! { "<leader>e", false, },
                    list! { "<leader>E", false, },
                    list! { "<leader>fe", false, },
                    list! { "<leader>fE", false, },
                    list! {
                        "<leader>ew", fun(lua, r#"
                            require("neo-tree.command").execute({
                                toggle = true,
                                dir = require("lazyvim.util").get_root(),
                            })
                        "#.to_string())?,
                    },
                    list! {
                        "<leader>ee", fun(lua, r#"
                            require("neo-tree.command").execute({
                                toggle = true,
                                dir = vim.loop.cwd(),
                            })
                        "#.to_string())?,
                    },
                },
                "opts", tbl! {
                    "window", tbl! {
                        "position", "right",
                        "width", 30,
                    },
                },
            },
            tbl! {
                1, "williamboman/mason.nvim",
                "opts", lua.create_function(|_, (_, opts): (LuaTable, LuaTable)| {
                    let value = tbl!();
                    opts.set("ensure_installed", value)?;
                    Ok(())
                })?,
                "config", lua.create_function(|lua, (_, opts): (LuaTable, LuaTable)| {
                    lua.globals()
                        .get::<_, LuaFunction>("require")?
                        .call::<_, LuaTable>("mason")?
                        .get::<_, LuaFunction>("setup")?
                        .call::<_, LuaTable>(opts)?;
                    Ok(())
                })?,
            },
            tbl! {
                1, "neovim/nvim-lspconfig",
                "init", fun(lua, r#"
                    local keymaps = require("lazyvim.plugins.lsp.keymaps")
                    local keys = keymaps.get()
                    keys[#keys + 1] = { "[g", keymaps.diagnostic_goto(false) }
                    keys[#keys + 1] = { "]g", keymaps.diagnostic_goto(true) }
                "#.to_string())?,
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
            tbl! {
                1, "echasnovski/mini.comment",
                "opts", tbl! {
                    "hooks", tbl! {
                        "pre", lua.create_function(|_, _: ()| {Ok(())})?,
                    },
                },
            },
            tbl! {
                1, "echasnovski/mini.surround",
                "opts", tbl! {
                    "mappings", tbl! {
                        "add", "S",
                        "delete", "ds",
                        "replace", "cs",
                    },
                },
            },
        },
    };

    Ok(opts)
}
