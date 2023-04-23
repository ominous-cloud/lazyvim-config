return {
    { "folke/neodev.nvim", enabled = false },
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
