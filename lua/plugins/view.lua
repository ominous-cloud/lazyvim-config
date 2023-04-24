return {
    { "echasnovski/mini.bufremove", enabled = false },
    --  { "lewis6991/gitsigns.nvim", enabled = false },
    { "akinsho/bufferline.nvim",    enabled = false },
    { "nvim-lualine/lualine.nvim",  enabled = false },
    { "SmiteshP/nvim-navic",        enabled = false },
    -- { "lukas-reineke/indent-blankline.nvim", enabled = false },
    -- { "echasnovski/mini.indentscope", enabled = false },
    { "echasnovski/mini.ai",        enabled = false },
    { "folke/which-key.nvim",       enabled = false },
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
