---@param opts PluginLspOpts
local function mason_off(opts)
  vim.iter(opts.servers):each(function(_, v)
    if v.mason == nil then
      v.mason = false
    end
  end)
  return opts
end

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
        { "[g", vim.diagnostic.goto_prev, desc = "previous diagnostic" },
        { "]g", vim.diagnostic.goto_next, desc = "next diagnostic" },
      }
    end,
    opts = mason_off {
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
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
              },
            },
          },
        },
        nil_ls = {
          settings = {
            ["nil"] = {
              formatting = {
                command = { "nixpkgs-fmt" },
              },
            },
          },
        },
        clangd = {},
        cmake = {},
        hls = {},
        jsonls = {},
        pyright = {},
        ruff_lsp = {},
        rust_analyzer = {},
        taplo = {},
        texlab = {},
        tsserver = {},
        wgsl_analyzer = {},
      },
      setup = {
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
    enabled = false,
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
