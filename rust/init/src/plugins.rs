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

pub fn noop(lua: &Lua) -> LuaResult<LuaFunction> {
    lua.create_function(|_, _: ()| {
        Ok(())
    })
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
                    "colorscheme", lua.create_function(|lua, _: ()| {
                        let opts = tbl! {
                            "style", "dark",
                            "palette_overrides", tbl! {
                                "background", "NONE",
                            },
                            "override", tbl! {
                                "Normal", tbl! {
                                    "fg", "#beb6ca",
                                    "bg", "NONE",
                                },
                            },
                        };
                        lua.globals()
                            .get::<_, LuaFunction>("require")?
                            .call::<_, LuaTable>("decay")?
                            .get::<_, LuaFunction>("setup")?
                            .call::<_, LuaTable>(opts)?;
                        Ok(())
                    })?,
                },
            },
            tbl! {
                "import", "lazyvim.plugins.extras.dap.core",
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
            disable(lua, "folke/tokyonight.nvim")?,
            // tbl! {
            //     1, "folke/tokyonight.nvim",
            //     "opts", tbl! {
            //         "transparent", true,
            //         "styles", tbl! {
            //             "sidebars", "transparent",
            //             "floats", "transparent",
            //         },
            //     },
            // },
            tbl! {
                1, "decaycs/decay.nvim",
                "config", noop(lua)?,
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
                    "diagnostics", tbl! {
                        "virtual_text", false,
                    },
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
                1, "mfussenegger/nvim-dap",
                "config", fun(lua, r#"
                    print("hello rust")
                    local Config = require("lazyvim.config")
                    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

                    for name, sign in pairs(Config.icons.dap) do
                        sign = type(sign) == "table" and sign or { sign }
                        vim.fn.sign_define("Dap" .. name, {
                            text = sign[1],
                            texthl = sign[2] or "DiagnosticInfo",
                            linehl = sign[3],
                            numhl = sign[3],
                        })
                    end

                    local dap = require("dap")
                    local utils = require("dap.utils")
                    dap.adapters.codelldb = {
                        type = "server",
                        port = "${port}",
                        executable = {
                            command = "codelldb",
                            args = { "--port", "${port}" },
                            -- detached = false,
                        }
                    }
                    local codelldb_launch_config = {
                        name = "codelldb: Launch",
                        type = "codelldb",
                        request = "launch",
                        program = function()
                            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                        end,
                        cwd = function()
                            return vim.fn.input("Working Directory > ", vim.fn.getcwd() .. "/", "file")
                        end,
                        stopOnEntry = false,
                        runInTerminal = false,
                    }
                    local codelldb_attach_config = {
                        name = "codelldb: Attach to process",
                        type = "codelldb",
                        request = "attach",
                        pid = utils.pick_process,
                        args = {},
                    }
                    local codelldb_configs = {
                        codelldb_launch_config,
                        codelldb_attach_config,
                    }
                    dap.configurations.cpp = codelldb_configs
                    dap.configurations.rust = codelldb_configs
                "#.to_string())?,
            },
            tbl! {
                1, "rcarriga/nvim-dap-ui",
                "opts", tbl! {
                    "expand_lines", false,
                    "layouts", tbl! {
                        1, tbl! {
                            "elements", list! {
                                tbl! { "id", "breakpoints", "size", 0.2, },
                                tbl! { "id", "stacks", "size", 0.2, },
                                tbl! { "id", "watches", "size", 0.2, },
                                tbl! { "id", "scopes", "size", 0.4, },
                            },
                            "size", 50,
                            "position", "right",
                        },
                    },
                    "icons", tbl! {
                        "expanded", "",
                        "collapsed", "",
                        "current_frame", "",
                    },
                },
            },
            tbl! {
                1, "nvim-telescope/telescope.nvim",
                "keys", list! {
                    list! { "<leader><space>", false, },
                    list! {
                        "<leader>fr", fun(lua, r#"
                            require("lazyvim.util").telescope("live_grep")()
                        "#.to_string())?,
                    },
                    list! {
                        "<leader>fR", fun(lua, r#"
                            require("lazyvim.util").telescope("live_grep", { cwd = false })()
                        "#.to_string())?,
                    },
                    list! {
                        "<leader>fe", fun(lua, r#"
                            require("lazyvim.util").telescope("files")()
                        "#.to_string())?,
                    },
                    list! {
                        "<leader>fE", fun(lua, r#"
                            require("lazyvim.util").telescope("files", { cwd = false })()
                        "#.to_string())?,
                    },
                },
            },
            tbl! {
                1, "echasnovski/mini.comment",
                "opts", tbl! {
                    "hooks", tbl! {
                        "pre", noop(lua)?,
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
