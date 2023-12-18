return {
  -- { "folke/neodev.nvim", enabled = false },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keymaps = require "lazyvim.plugins.lsp.keymaps"
      local keys = keymaps.get()
      local function add(maps)
        vim.iter(maps):each(function(config)
          keys[#keys + 1] = config
        end)
      end
      add {
        { "[g", vim.diagnostic.goto_prev },
        { "]g", vim.diagnostic.goto_next },
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
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
      }
    }
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
      },
    },
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
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    config = function()
      require("flutter-tools").setup {
        widget_guides = {
          enabled = true,
        },
        lsp = {
          cmd = { "dart", "language-server", "--protocol=lsp" },
        },
      }
    end,
  },
}
