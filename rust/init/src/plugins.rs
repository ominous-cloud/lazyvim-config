use common::{list, tbl};
use mlua::prelude::*;

pub fn disable<'a, 'b>(lua: &'a Lua, s: &'b str) -> LuaResult<LuaTable<'a>> {
    Ok(tbl! { lua;
        1, s,
        "enabled", false,
    })
}

pub fn default(lua: &Lua) -> LuaResult<LuaTable> {
    let opts = tbl! { lua;
        "spec", list! { lua;
            tbl! { lua;
                1, "LazyVim/LazyVim",
                "import", "lazyvim.plugins",
                "opts", tbl! { lua;
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
            tbl! { lua;
                1, "folke/tokyonight.nvim",
                "opts", tbl! { lua;
                    "transparent", true,
                    "styles", tbl! { lua;
                        "sidebars", "transparent",
                        "floats", "transparent",
                    },
                },
            },
            tbl! { lua;
                1, "rcarriga/nvim-notify",
                "opts", tbl! { lua;
                    "background_colour", "#000000",
                },
            },
            tbl! { lua;
                1, "folke/noice.nvim",
                "opts", tbl! { lua;
                    "presets", tbl! { lua;
                        "command_palette", false,
                    },
                    "cmdline", tbl! { lua;
                        "enable", true,
                        "view", "cmdline",
                    },
                    "lsp", tbl! { lua;
                        "signature", tbl! { lua;
                            "auto_open", tbl! { lua;
                                "enabled", false,
                            },
                        },
                    },
                },
            },
            tbl! { lua;
                1, "goolord/alpha-nvim",
                "config", lua.create_function(|lua, _: ()| {
                    let config = lua.globals()
                        .get::<_, LuaFunction>("require")?
                        .call::<_, LuaTable>("alpha.themes.startify")?
                        .get::<_, LuaTable>("config")?;
                    config
                        .get::<_, LuaTable>("layout")?
                        .get::<_, LuaTable>(2)?
                        .set("val", "しゃがみガード")?;
                    lua.globals()
                        .get::<_, LuaFunction>("require")?
                        .call::<_, LuaTable>("alpha")?
                        .get::<_, LuaFunction>("setup")?
                        .call::<_, LuaTable>(config)?;

                    Ok(())
                })?,
            },
            tbl! { lua;
                1, "nvim-neo-tree/neo-tree.nvim",
                "opts", tbl! { lua;
                    "window", tbl! { lua;
                        "position", "right",
                        "width", 30,
                    },
                },
            },
            tbl! { lua;
                1, "williamboman/mason.nvim",
                "opts", lua.create_function(|lua, (_, opts): (LuaTable, LuaTable)| {
                    let value = tbl!(lua;);
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
            tbl! { lua;
                1, "neovim/nvim-lspconfig",
                "opts", tbl! { lua;
                    "autoformat", false,
                    "servers", tbl! { lua;
                        "jsonls", tbl! { lua;
                            "mason", false,
                        },
                        "lua_ls", tbl! { lua;
                            "mason", false,
                        },
                        "rust_analyzer", tbl! { lua;
                            "mason", false,
                        },
                    },
                },
            },
            tbl! { lua;
                1, "echasnovski/mini.comment",
                "opts", tbl! { lua;
                    "hooks", tbl! { lua;
                        "pre", lua.create_function(|_, _: ()| {Ok(())})?,
                    },
                },
            },
        },
    };

    Ok(opts)
}
