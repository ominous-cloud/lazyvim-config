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
    { "rcarriga/nvim-notify",                enabled = false },
    { "folke/noice.nvim",                    enabled = false },
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
            { "<leader>,",       false, },
            { "<leader>:",       false, },
            { "<leader>/",       false, },
            { "<leader><space>", false, },
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
            },
            fzf_opts = {
                ["--keep-right"] = "",
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
}
