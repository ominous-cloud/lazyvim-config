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
            local function add(maps)
                for _, config in ipairs(maps) do
                    keys[#keys + 1] = config
                end
            end
            add {
                { "[g", keymaps.diagnostic_goto(false) },
                { "]g", keymaps.diagnostic_goto(true) },
                {
                    "<leader>cF",
                    format_slow,
                    has = "documentFormatting"
                },
                {
                    "<leader>cF",
                    format_slow,
                    mode = "v",
                    has = "documentRangeFormatting"
                },
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
                nil_ls = {
                    mason = false,
                    settings = {
                        ["nil"] = {
                            formatting = {
                                command = { "nixpkgs-fmt" },
                            },
                        },
                    },
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
                    handlers = {
                        ['language/status'] = vim.schedule_wrap(function(_, result)
                            vim.cmd "echohl ModeMsg"
                            if result.message ~= nil then
                                print(result.message)
                                vim.cmd(string.format("echo \"%s\"", result.message))
                            end
                            vim.cmd "echohl None"
                        end),
                        ["$/progress"] = vim.schedule_wrap(function(_, result)
                            vim.cmd "echohl ModeMsg"
                            if result.message ~= nil then
                                print(result.message)
                                vim.cmd(string.format("echo \"%s\"", result.message))
                            end
                            vim.cmd "echohl None"
                        end),
                    },
                },
                tsserver = {
                    mason = false,
                },
                volar = {
                    mason = false,
                    filetypes = { "vue" },
                },
                clangd = {
                    mason = false,
                    filetypes = { "c", "cpp" },
                },
                hls = {
                    mason = false,
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
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {},
        },
    },
}
