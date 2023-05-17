return {
    { "echasnovski/mini.bufremove",          enabled = false },
    { "lewis6991/gitsigns.nvim",             enabled = false },
    { "akinsho/bufferline.nvim",             enabled = false },
    { "nvim-lualine/lualine.nvim",           enabled = false },
    { "SmiteshP/nvim-navic",                 enabled = false },
    { "lukas-reineke/indent-blankline.nvim", enabled = false },
    { "echasnovski/mini.indentscope",        enabled = false },
    { "echasnovski/mini.ai",                 enabled = false },
    { "RRethy/vim-illuminate",               enabled = false },
    { "folke/which-key.nvim",                enabled = false },
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
                view_search = "mini",
            },
            notify = {
                enabled = true,
                view = "mini",
            },
            lsp = {
                progress = {
                    enable = false,
                    view = "mini",
                    format = {
                        {
                            "{spinner} ",
                            hl_group = "NoiceLspProgressSpinner",
                        },
                        {
                            "{data.progress.title} ",
                            hl_group = "NoiceLspProgressTitle",
                        },
                        {
                            "{data.progress.client} ",
                            hl_group = "NoiceLspProgressClient",
                        },
                    },
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
            config.layout[2] = {
                type = "text",
                val = "しゃがみガード",
            }
            require "alpha".setup(config)
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            's1n7ax/nvim-window-picker',
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
                        dir = require "lazyvim.util".get_root(),
                    })
                end,
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
            },
            {
                "<leader>ee",
                function()
                    require "neo-tree.command".execute({
                        toggle = true,
                        source = "buffers",
                    })
                end,
            },
        },
        opts = {
            source_selector = {
                sources = {
                    { source = "filesystem", display_name = "  Files " },
                    { source = "buffers",    display_name = "  Buffers " },
                    -- { source = "git_status", display_name = "  Git " },
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
            },
        },
    },
    {
        "stevearc/aerial.nvim",
        keys = {
            {
                "<leader>er", "<cmd>AerialToggle!<cr>",
            },
        },
        opts = {
            backends = { "lsp", "treesitter", "markdown", "man" },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
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
}
