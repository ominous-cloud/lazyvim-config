return {
    -- { "folke/neodev.nvim", enabled = false },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.tex" },
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
                virtual_text = true,
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
                rust_analyzer = {
                    mason = false,
                },
                taplo = {
                    mason = false,
                },
                clangd = {
                    mason = false,
                    keys = {
                        { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
                    },
                    root_dir = function(fname)
                        return require("lspconfig.util").root_pattern(
                            "Makefile",
                            "configure.ac",
                            "configure.in",
                            "config.h.in",
                            "meson.build",
                            "meson_options.txt",
                            "build.ninja"
                        )(fname) or require("lspconfig.util").root_pattern(
                            "compile_commands.json",
                            "compile_flags.txt"
                        )(fname) or require("lspconfig.util").find_git_ancestor(fname)
                    end,
                    capabilities = {
                        offsetEncoding = { "utf-16" },
                    },
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                },
                cmake = {
                    mason = false,
                },
                hls = {
                    mason = false,
                },
                texlab = {
                    mason = false,
                },
                pyright = {
                    mason = false,
                },
                ruff_lsp = {
                    mason = false,
                },
                wgsl_analyzer = {
                    mason = false,
                },
            },
            setup = {
                volar = function(_, opts)
                    opts.root_dir = require "lspconfig".util.root_pattern {
                        "package.json", "package.yaml", "node_modules", ".git",
                    }
                end,
                clangd = function(_, opts)
                    local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
                    require("clangd_extensions").setup(vim.tbl_deep_extend("force",
                        clangd_ext_opts or {}, {
                            server = opts,
                        }))
                    return false
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
        opts = function(_, opts)
            opts.ensure_installed = {}
        end,
    },
    {
        "simrat39/rust-tools.nvim",
        lazy = true,
        opts = {
            tools = {
                on_initialized = function()
                end,
            },
        },
        config = function()
        end,
    },
    {
        "lervag/vimtex",
        lazy = false, -- lazy-loading will disable inverse search
        config = function()
            vim.api.nvim_create_autocmd({ "FileType" }, {
                group = vim.api.nvim_create_augroup("lazyvim_vimtex_conceal", { clear = true }),
                pattern = { "bib", "tex" },
                callback = function()
                    vim.wo.conceallevel = 0
                end,
            })

            vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
            vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
            vim.g.vimtex_imaps_enabled = false
            vim.g.vimtex_compiler_method = "generic"
            vim.g.vimtex_compiler_generic = {
                command = "ls",
            }
        end,
    },
    {
        "kaarmu/typst.vim",
        ft = "typst",
        lazy = false,
    },
}
