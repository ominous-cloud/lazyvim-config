return {
  { "akinsho/bufferline.nvim",   enabled = false },
  { "nvim-lualine/lualine.nvim", enabled = false },
  { "SmiteshP/nvim-navic",       enabled = false },
  -- { "folke/which-key.nvim",   enabled = false },
  { "rcarriga/nvim-notify",      enabled = false },
  { "folke/noice.nvim",          enabled = false },
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        registers = false,
        spelling = {
          enable = false,
        },
      },
    },
  },
  {
    "goolord/alpha-nvim",
    config = function()
      local config = require "alpha.themes.startify".config
      config.layout[2] = {
        type = "text",
        val = "しゃがみガード",
      }
      require "alpha".setup(config)
    end,
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      { "<leader>fd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>fD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "s1n7ax/nvim-window-picker",
      keys = {
        {
          "<leader>wp",
          function()
            local picked_window_id = require "window-picker".pick_window()
                or vim.api.nvim_get_current_win()
            vim.api.nvim_set_current_win(picked_window_id)
          end,
          desc = "Pick a window",
        },
      },
      config = function()
        require "window-picker.config".include_current_win = true
        require "window-picker".setup_completed = true
      end,
    },
    keys = {
      { "<leader>e",  false, },
      { "<leader>E",  false, },
      { "<leader>fe", false, },
      { "<leader>fE", false, },
      {
        "<leader>ew",
        function()
          require "neo-tree.command".execute({
            toggle = true,
            source = "filesystem",
            dir = require "lazyvim.util".root.get(),
          })
        end,
        desc = "neotree root"
      },
      {
        "<leader>eW",
        function()
          require "neo-tree.command".execute({
            toggle = true,
            source = "filesystem",
            dir = vim.loop.cwd(),
          })
        end,
        desc = "neotree cwd"
      },
      {
        "<leader>ee",
        function()
          require "neo-tree.command".execute({
            toggle = true,
            source = "buffers",
          })
        end,
        desc = "neotree buffer"
      },
    },
    opts = {
      close_if_last_window = true,
      source_selector = {
        sources = {
          { source = "filesystem" },
          { source = "buffers" },
        },
      },
      window = {
        position = "right",
        width = 30,
        mappings = {
          h = "toggle_node",
          l = "open_with_window_picker",
          e = "vsplit_with_window_picker",
          E = "split_with_window_picker",
        },
      },
      filesystem = {
        -- create file using "../newfile"
        group_empty_dirs = true,
        hijack_netrw_behavior = "open_default",
        -- hijack_netrw_behavior = "disabled",
      },
      default_component_configs = {
        git_status = {
          symbols = {
            added     = "",
            modified  = "",
            deleted   = "",
            renamed   = "",
            -- Status type
            untracked = "󰄱",
            ignored   = "",
            unstaged  = "󰄗",
            staged    = "󰱒",
            conflict  = "",
          },
        },
      },
    },
  },
  {
    'stevearc/oil.nvim',
    opts = {
      default_file_explorer = false,
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<leader>er", "<cmd>AerialToggle!<cr>" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>,",       false },
      { "<leader>:",       false },
      { "<leader>/",       false },
      { "<leader><space>", false },
      { "<leader>fb",      false },
      { "<leader>ff",      false },
      { "<leader>fF",      false },
      { "<leader>fr",      false },
      { "<leader>fR",      false },
      { "<leader>sd",      false },
      { "<leader>sD",      false },
      -- try <leader>sr to use spectre
      {
        "<leader>Fr",
        function()
          require "lazyvim.util".telescope("live_grep")()
        end,
        desc = "telescope live_grep",
      },
      {
        "<leader>FR",
        function()
          require "lazyvim.util".telescope("live_grep", { cwd = false })()
        end,
        desc = "telescope live_grep",
      },
      {
        "<leader>Fe",
        function()
          require "lazyvim.util".telescope("files")()
        end,
        desc = "telescope files",
      },
      {
        "<leader>FE",
        function() require "lazyvim.util".telescope("files", { cwd = false })() end,
        desc = "telescope files",
      },
      {
        "<leader>Sd",
        "<cmd>Telescope diagnostics bufnr=0<cr>",
        desc = "Document diagnostics",
      },
      {
        "<leader>SD",
        "<cmd>Telescope diagnostics<cr>",
        desc = "Workspace diagnostics",
      },
    },
    opts = {
      defaults = {
        path_display = { "smart" },
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- just use default keymaps like <c-v>
      -- default layout is ok
      winopts = {
        -- split = "belowright vnew", -- if you like
        preview = {
          hidden = "hidden",
        },
      },
      fzf_opts = {
        ["--keep-right"] = "",
      },
      keymap = {
        builtin = {
        },
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
    },
    keys = {
      -- <f1> for help
      {
        "<leader>,",
        function()
          require "fzf-lua".buffers()
        end,
        desc = "fzf buffers",
      },
      {
        "<leader>/",
        function()
          require "fzf-lua".live_grep()
        end,
        desc = "fzf grep",
      },
      {
        "<leader>sf",
        function()
          require "fzf-lua".builtin()
        end,
        desc = "fzf builtin",
      },
      {
        "<leader>fr",
        function()
          require "fzf-lua".live_grep()
        end,
        desc = "fzf grep",
      },
      {
        "<leader>fe",
        function()
          require "fzf-lua".files()
        end,
        desc = "fzf files",
      },
      {
        "<leader>fb",
        function()
          require "fzf-lua".buffers()
        end,
        desc = "fzf buffers",
      },
      {
        "<leader>sd",
        function()
          require "fzf-lua".diagnostics_document()
        end,
        desc = "fzf all diagnostics",
      },
      {
        "<leader>sD",
        function()
          require "fzf-lua".diagnostics_workspace()
        end,
        desc = "fzf diagnostics",
      },
    }
  },
  -- Wrong offset when getting file name
  {
    "lstwn/broot.vim",
    config = function()
      vim.keymap.set("n", "<leader>en", "<cmd>Broot<cr>", {
        noremap = true,
        silent = true,
      })
    end,
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 0.80,
      },
    },
    keys = {
      {
        "<leader>fp", "<cmd>ZenMode<cr>", desc = "zenmode",
      },
    },
  },
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function() require "competitest".setup {} end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {},
  },
}
