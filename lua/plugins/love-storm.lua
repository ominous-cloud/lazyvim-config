local function default_color()
    local function transparent(group)
        local none = "NONE"
        vim.api.nvim_set_hl(0, group, { bg = none })
    end
    local function unbold(group)
        vim.api.nvim_set_hl(0, group, { bold = false })
    end
    vim.cmd.colorscheme "default"
    transparent "Normal"
    transparent "StatusLine"
    unbold "Keyword"
end

return {
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = default_color,
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        enabled = false,
        opts = {
            flavour = "mocha",
            transparent_background = true,
            show_end_of_buffer = false,
            dim_inactive = {
                enabled = false,
            },
            no_italic = false,
            no_bold = false,
            no_underline = false,
            styles = {
                comments = { "italic" },
                conditionals = { },
                keywords = { },
            },
            color_overrides = {},
            custom_highlights = {
                ["@parameter"] = { style = { } },
            },
        },
    },
    {
        "folke/tokyonight.nvim",
        enabled = false,
        opts = {
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
    },
}
