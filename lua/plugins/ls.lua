return {
    -- { "folke/neodev.nvim", enabled = false },
    {
        "neovim/nvim-lspconfig",
        init = function()
            local keymaps = require "lazyvim.plugins.lsp.keymaps"
            local keys = keymaps.get()
            local format_slow = function()
                local buf = vim.api.nvim_get_current_buf()
                local ft = vim.bo[buf].filetype
                local sources = require "null-ls.sources"
                local have_nls = #sources.get_available(ft, "NULL_LS_FORMATTING") > 0
                local opts = vim.tbl_deep_extend("force", {
                    timeout_ms = 2000,
                    bufnr = buf,
                    filter = function(client)
                        if have_nls then
                            return client.name == "null-ls"
                        end
                        return client.name ~= "null-ls"
                    end,
                }, require "lazyvim.util".opts("nvim-lspconfig").format or {})
                vim.lsp.buf.format(opts)
            end
            keys[#keys + 1] = {
                "[g", keymaps.diagnostic_goto(false),
            }
            keys[#keys + 1] = {
                "]g", keymaps.diagnostic_goto(true),
            }
            keys[#keys + 1] = {
                "<leader>cF", format_slow,
                has = "documentFormatting",
            }
            keys[#keys + 1] = {
                "<leader>cF", format_slow,
                mode = "v",
                has = "documentRangeFormatting",
            }
        end,
        opts = {
            diagnostics = {
                virtual_text = false,
                signs = {
                    severity = {
                        min = vim.diagnostic.severity.WARN
                    }
                },
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
    {
        "jose-elias-alvarez/null-ls.nvim",
        opts = function()
            local null_ls = require "null-ls";
            return {
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.eslint_d,
                },
            }
        end,
    },
}
