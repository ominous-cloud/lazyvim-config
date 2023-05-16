return {
    { "ggandor/leap.nvim",        enabled = false },
    { "ggandor/flit.nvim",        enabled = false },
    -- { "nvim-treesitter/nvim-treesitter", enabled = false },
    { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
    { "folke/todo-comments.nvim", enabled = false },
    { "echasnovski/mini.pairs",   enabled = false },
    {
        "hrsh7th/nvim-cmp",
        opts = {
            completion = {
                autocomplete = false,
            },
            experimental = {
                ghost_text = false,
                -- ghost_text = {
                --     hl_group = "LspCodeLens",
                -- },
            },
        },
    },
    {
        "L3MON4D3/LuaSnip",
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
}
