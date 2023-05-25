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
                preview = {
                    hidden = "hidden",
                },
            },
            fzf_opts = {
                ["--keep-right"] = "",
            },
            keymap = {
                builtin = {
                    ["<c-z>"]    = "toggle-preview",
                    ["<f1>"]     = "toggle-help",
                    ["<f2>"]     = "toggle-fullscreen",
                    ["<f3>"]     = "toggle-preview-wrap",
                    ["<f4>"]     = "toggle-preview",
                    ["<f5>"]     = "toggle-preview-ccw",
                    ["<f6>"]     = "toggle-preview-cw",
                    ["<c-d>"]    = "preview-page-down",
                    ["<c-u>"]    = "preview-page-up",
                    ["<s-left>"] = "preview-page-reset",
                },
                fzf = {
                    ["ctrl-z"] = "toggle-preview",
                    ["ctrl-f"] = "half-page-down",
                    ["ctrl-b"] = "half-page-up",
                    ["ctrl-a"] = "beginning-of-line",
                    ["ctrl-e"] = "end-of-line",
                    ["alt-a"]  = "toggle-all",
                    ["f3"]     = "toggle-preview-wrap",
                    ["f4"]     = "toggle-preview",
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
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
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = { "tpope/vim-dadbod" },
        config = function()
            vim.g.db_ui_show_help = false
            vim.g.db_ui_winwidth = 30
            vim.g.db_ui_win_position = "right"
            vim.g.db_ui_force_echo_notifications = true
            vim.g.db_ui_disable_mappings = true

            -- default mappings
            vim.api.nvim_create_augroup("DBUIFileType", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "dbui" },
                group = "DBUIFileType",
                callback = function()
                    local db_ui_map = vim.fn["db_ui#utils#set_mapping"]
                    db_ui_map({ "o", "<cr>" }, "<Plug>(DBUI_SelectLine)")
                    db_ui_map("S", "<Plug>(DBUI_SelectLineVsplit)")
                    db_ui_map("R", "<Plug>(DBUI_Redraw)")
                    db_ui_map("d", "<Plug>(DBUI_DeleteLine)")
                    db_ui_map("A", "<Plug>(DBUI_AddConnection)")
                    db_ui_map("H", "<Plug>(DBUI_ToggleDetails)")
                    db_ui_map("r", "<Plug>(DBUI_RenameLine)")
                    db_ui_map("q", "<Plug>(DBUI_Quit)")
                    db_ui_map("<c-k>", "<Plug>(DBUI_GotoFirstSibling)")
                    db_ui_map("<c-j>", "<Plug>(DBUI_GotoLastSibling)")
                    db_ui_map("<C-p>", "<Plug>(DBUI_GotoParentNode)")
                    db_ui_map("<C-n>", "<Plug>(DBUI_GotoChildNode)")
                    db_ui_map("K", "<Plug>(DBUI_GotoPrevSibling)")
                    db_ui_map("J", "<Plug>(DBUI_GotoNextSibling)")
                end,
            })

            vim.api.nvim_create_augroup("SQLFileType", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "plsql", "mysql" },
                group = "SQLFileType",
                callback = function()
                    local db_ui_map = vim.fn["db_ui#utils#set_mapping"]
                    -- db_ui_map("<leader>W", "<Plug>(DBUI_SaveQuery)")
                    -- db_ui_map("<leader>E", "<Plug>(DBUI_EditBindParameters)")
                    db_ui_map("<leader>cj", "<Plug>(DBUI_ExecuteQuery)")
                    db_ui_map("<leader>cj", "<Plug>(DBUI_ExecuteQuery)", "v")
                end,
            })
        end,
        keys = {
            {
                "<leader>eb", "<cmd>DBUIToggle<cr>",
            },
        },
    },
}
