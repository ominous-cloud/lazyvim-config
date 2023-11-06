return {
    { "lewis6991/gitsigns.nvim",                     enabled = false },
    -- { "lukas-reineke/indent-blankline.nvim",         enabled = false },
    -- { "echasnovski/mini.indentscope",                enabled = false },
    { "echasnovski/mini.ai",                         enabled = false },
    { "ggandor/leap.nvim",                           enabled = false },
    { "ggandor/flit.nvim",                           enabled = false },
    { "folke/flash.nvim",                            enabled = false },
    -- { "nvim-treesitter/nvim-treesitter", enabled = false },
    { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
    { "nvim-treesitter/nvim-treesitter-context",     enabled = false },
    { "folke/todo-comments.nvim",                    enabled = false },
    { "echasnovski/mini.pairs",                      enabled = false },
    { "rafamadriz/friendly-snippets",                enabled = false },
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            local cmp = require "cmp"
            opts.completion = {
                autocomplete = false,
            }
            opts.experimental = {
                ghost_text = false,
            }
            opts.mapping = cmp.mapping.preset.insert({
                ["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                ["<c-f>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.scroll_docs(4)
                    else
                        cmp.complete()
                    end
                end, { "i", "s" }),
                ["<c-e>"] = cmp.mapping.abort(),
                ["<cr>"] = cmp.mapping.confirm({ select = true }),
                ["<s-cr>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                })
            })
            -- opts.mapping["<C-Space>"] = nil
            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<c-f>"] = cmp.mapping.complete(),
            })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp LUA_LDLIBS=-lluajit-5.1",
        keys = {
            { "<tab>", false, mode = "i" },
            {
                "<c-l>",
                function() require "luasnip".jump(1) end,
                expr = true,
                silent = true,
                mode = { "i", "s" },
            },
        },
        config = function()
            require "luasnip.loaders.from_lua".load({
                paths = vim.fn.stdpath("config") .. "/snippets",
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "bash",
                "c", "c_sharp", "cmake", "comment", "cpp", "css",
                "dart", "diff", "dockerfile", "dot",
                "git_rebase", "gitcommit", "gitignore",
                "haskell", "html", "java", "javascript", "json", "jsonc",
                "kotlin", "latex", "lua",
                "make", "markdown", "markdown_inline",
                "nix", "python", "qmljs", "query", "rust", "scss", "sql",
                "tsx", "typescript", "vue", "yaml",
                "wgsl",
            },
        },
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        keys = {
            "za",
            { "zR", function() require "ufo".openAllFolds() end },
            { "zM", function() require "ufo".closeAllFolds() end },
            { "zr", function() require "ufo".openFoldsExceptKinds() end },
            { "zm", function() require "ufo".closeFoldsWith() end },
        },
        config = function(_, opts)
            require "ufo".setup(opts)
        end,
    },
    {
        "echasnovski/mini.surround",
        keys = {
            "S", "ds", "cs"
        },
        opts = {
            mappings = {
                add = "S",
                delete = "ds",
                replace = "cs",
            },
        },
    },
    {
        "RRethy/vim-illuminate",
        event = function() return {} end,
        opts = { delay = 200 },
        config = function(_, opts)
            require "illuminate".configure(opts)
            require "illuminate".toggle()
        end,
        keys = {
            {
                "g[",
                function() require "illuminate".toggle() end,
                desc = "Toggle Illuminate",
            },
            {
                "g{",
                function() require "illuminate".goto_prev_reference(false) end,
                desc = "Prev Reference",
            },
            {
                "g}",
                function() require "illuminate".goto_next_reference(false) end,
                desc = "Next Reference",
            },
        },
    },
    {
        "echasnovski/mini.indentscope",
        config = function(_, opts)
            local animation = require('mini.indentscope').gen_animation.none()
            opts.draw = opts.draw or {}
            opts.draw.delay = 10
            opts.draw.animation = animation
            require 'mini.indentscope'.setup(opts)
        end,
    },
    {
        "h-hg/fcitx.nvim",
        lazy = false,
    },
}
