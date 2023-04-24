return {
    {
        "LazyVim/LazyVim",
        priority = 1000,
        import = "lazyvim.plugins",
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
            end,
        },
    },
}
