return {
    {
        "LazyVim/LazyVim",
        import = "lazyvim.plugins",
        opts = {
            colorscheme = "tokyonight",
        },
    },
    {
        import = "lazyvim.plugins.extras.dap.core",
    },

    -- override default config
    { "folke/neodev.nvim",          enabled = false },
    { "ggandor/leap.nvim",          enabled = false },
    { "ggandor/flit.nvim",          enabled = false },
    -- { "nvim-treesitter/nvim-treesitter", enabled = false },
    -- { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
    { "folke/todo-comments.nvim",   enabled = false },
    { "echasnovski/mini.pairs",     enabled = false },
    { "echasnovski/mini.bufremove", enabled = false },
    --  { "lewis6991/gitsigns.nvim", enabled = false },
    { "akinsho/bufferline.nvim",    enabled = false },
    { "nvim-lualine/lualine.nvim",  enabled = false },
    { "SmiteshP/nvim-navic",        enabled = false },
    -- { "lukas-reineke/indent-blankline.nvim", enabled = false },
    -- { "echasnovski/mini.indentscope", enabled = false },
    { "echasnovski/mini.ai",        enabled = false },
    { "folke/which-key.nvim",       enabled = false },
    { "catppuccin/nvim",            enabled = false },

    {
        "folke/tokyonight.nvim",
        opts = {
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
    },
    {
        "rcarriga/nvim-notify",
        opts = {
            background_colour = "#000000",
        },
    },
    {
        "folke/noice.nvim",
        opts = {
            presets = {
                command_palette = false,
            },
            cmdline = {
                enable = true,
                view = "cmdline",
            },
            messages = {
                enable = true,
                view = "mini",
                view_error = "mini",
                view_warn = "mini",
            },
            lsp = {
                progress = {
                    enable = false,
                    view = "mini",
                },
                signature = {
                    auto_open = {
                        enabled = false,
                    },
                },
            },
        },
    },
    {
        "goolord/alpha-nvim",
        config = function()
            local config = require "alpha.themes.startify".config
            config.layout[2].val = "しゃがみガード"
            require "alpha".setup(config)
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = {
            { "<leader>e",  false, },
            { "<leader>E",  false, },
            { "<leader>fe", false, },
            { "<leader>fE", false, },
            {
                "<leader>ew", function()
                require "neo-tree.command".execute({
                    toggle = true,
                    dir = require "lazyvim.util".get_root(),
                })
            end,
            },
            {
                "<leader>ee", function()
                require "neo-tree.command".execute({
                    toggle = true,
                    dir = vim.loop.cwd(),
                })
            end,
            },
        },
        opts = {
            window = {
                position = "right",
                width = 30,
                mappings = {
                    h = "toggle_node",
                    l = "open",
                    e = "open_vsplit",
                    s = "open_split",
                },
            },
            filesystem = {
                -- create file using "../newfile"
                group_empty_dirs = true,
            },
        },
    },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {},
        },
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local Config = require "lazyvim.config"
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

            local dap = require "dap"
            local utils = require "dap.utils"
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
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        opts = {
            expand_lines = false,
            layouts = {
                {
                    elements = {
                        { id = "breakpoints", size = 0.2 },
                        { id = "stacks",      size = 0.2 },
                        { id = "watches",     size = 0.2 },
                        { id = "scopes",      size = 0.4 },
                    },
                    size = 50,
                    position = "right",
                },
            },
            icons = {
                expanded = "",
                collapsed = "",
                current_frame = "",
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader><space>", false, },
            {
                "<leader>fr", function()
                require "lazyvim.util".telescope("live_grep")()
            end,
            },
            {
                "<leader>fR", function()
                require "lazyvim.util".telescope("live_grep", { cwd = false })()
            end,
            },
            {
                "<leader>fe", function()
                require "lazyvim.util".telescope("files")()
            end,
            },
            {
                "<leader>fE", function()
                require "lazyvim.util".telescope("files", { cwd = false })()
            end,
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "bash",
                "c", "c_sharp", "cmake", "comment", "cpp", "css",
                "dart", "diff", "dockerfile", "dot",
                "git_rebase", "gitcommit", "gitignore",
                "haskell", "html", "java", "javascript", "json", "jsonc",
                "kotlin", "latex", "lua",
                "make", "markdown", "markdown_inline",
                "nix", "python", "qmljs", "query", "rust", "scss", "sql",
                "tsx", "typescript", "vue", "yaml",
            },
        },
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        keys = {
            "za",
            { "zR", function() require "ufo".openAllFolds() end },
            { "zM", function() require "ufo".closeAllFolds() end },
            { "zr", function() require "ufo".openFoldsExceptKinds() end },
            { "zm", function() require "ufo".closeFoldsWith() end },
        },
        config = function(_, opts)
            require "ufo".setup(opts)
        end,
    },
    {
        "echasnovski/mini.surround",
        keys = {
            "S", "ds", "cs"
        },
        opts = {
            mappings = {
                add = "S",
                delete = "ds",
                replace = "cs",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        init = function()
            local keymaps = require "lazyvim.plugins.lsp.keymaps"
            local keys = keymaps.get()
            keys[#keys + 1] = { "[g", keymaps.diagnostic_goto(false) }
            keys[#keys + 1] = { "]g", keymaps.diagnostic_goto(true) }
        end,
        opts = {
            diagnostics = {
                virtual_text = false,
            },
            autoformat = false,
            servers = {
                lua_ls = {
                    mason = false,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' },
                            },
                        },
                    },
                },
                jsonls = {
                    mason = false,
                },
                rust_analyzer = {
                    mason = false,
                },
                jdtls = {
                    mason = false,
                    cmd = {
                        "jdt-language-server",
                        "-configuration",
                        vim.fn.stdpath("cache") .. "/../jdtls/config",
                        "-data",
                        vim.fn.stdpath("cache") .. "/../jdtls/workspace",
                    },
                },
                volar = {
                    mason = false,
                    filetypes = { "typescript", "typescriptreact", "vue" },
                },
            },
            setup = {
                volar = function(_, opts)
                    opts.root_dir = require "lspconfig".util.root_pattern {
                        "package.json", "package.yaml", "node_modules", ".git",
                    }
                end,
                ["*"] = function()
                end,
            },
        },
    },
}
