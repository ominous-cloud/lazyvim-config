return {
    { "catppuccin/nvim", name = "catppuccin", enabled = false },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = function()
                local style = "dark";
                local colors = require "decay.core".get_colors(style)
                local fg = colors.foreground
                local bg = colors.background
                local accent = colors.accent
                local none = "NONE"

                require "decay".setup {
                    style = style,
                    palette_overrides = {
                        background = none,
                    },
                    override = {
                        Normal = {
                            fg = fg,
                            bg = none,
                        },
                        TelescopeSelection = {
                            fg = bg,
                            bg = accent,
                        },
                    },
                }

                for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
                  vim.api.nvim_set_hl(0, group, {})
                end
            end,
        },
    },
    {
        "folke/tokyonight.nvim",
        opts = {
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
    },
    {
        "decaycs/decay.nvim",
        config = function()
        end,
    },
}
