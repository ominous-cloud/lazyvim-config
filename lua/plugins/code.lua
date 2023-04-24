return {
    { "ggandor/leap.nvim",        enabled = false },
    { "ggandor/flit.nvim",        enabled = false },
    -- { "nvim-treesitter/nvim-treesitter", enabled = false },
    -- { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
    { "folke/todo-comments.nvim", enabled = false },
    { "echasnovski/mini.pairs",   enabled = false },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {},
        },
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