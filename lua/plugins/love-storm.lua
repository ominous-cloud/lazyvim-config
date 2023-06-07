local function colorful()
    local style = "dark"
    local colors = require "decay.core".get_colors(style)
    local fg = colors.foreground
    local bg = colors.background
    local dark = colors.black
    local none = "none"

    local palette_overrides = {
        dark0_hard = dark,
        dark0 = dark,
        dark0_soft = dark,
        dark1 = dark,
        dark2 = dark,
        dark3 = dark,
        dark4 = dark,
        light0_hard = fg,
        light0 = fg,
        light0_soft = fg,
        light1 = fg,
        light2 = fg,
        light3 = fg,
        light4 = fg,
        bright_red = fg,
        bright_green = fg,
        bright_yellow = fg,
        bright_blue = fg,
        bright_purple = fg,
        bright_aqua = fg,
        bright_orange = fg,
        neutral_red = fg,
        neutral_green = fg,
        neutral_yellow = fg,
        neutral_blue = fg,
        neutral_purple = fg,
        neutral_aqua = fg,
        neutral_orange = fg,
        faded_red = fg,
        faded_green = fg,
        faded_yellow = fg,
        faded_blue = fg,
        faded_purple = fg,
        faded_aqua = fg,
        faded_orange = fg,
        gray = fg,
    }

    local highlight_overrides = {
        -- LspCodeLens = {
        --     italic = false,
        -- },
        Todo = {
            fg = fg,
            bg = none,
        },
        NoiceLspProgressTitle = {
            fg = fg,
        },
        NeoTreeGitConflict = {
            fg = fg,
        },
        NeoTreeGitUntracked = {
            fg = fg,
        },
        NeoTreeModified = {
            fg = fg,
        },
        NvimWindoSwitch = {
            bg = fg,
            fg = dark,
            bold = false,
            italic = false,
        },
        NvimWindoSwitchNC = {
            bg = fg,
            fg = dark,
            bold = false,
            italic = false,
        },
        StatusLine = {
            bg = fg,
            fg = bg,
            italic = false,
        },
        StatusLineNC = {
            bg = fg,
            fg = bg,
            italic = true,
        },
    }

    require "gruvbox".setup({
        undercurl = true,
        underline = true,
        bold = false,
        italic = {
            strings = false,
            comments = false,
            operators = false,
            folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = false,
        contrast = "",
        dim_inactive = false,
        transparent_mode = true,
        palette_overrides = palette_overrides,
        overrides = highlight_overrides,
    })
    vim.cmd.colorscheme "gruvbox"

    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
        vim.api.nvim_set_hl(0, group, {})
    end

    require "nvim-web-devicons".setup {
        color_icons = false,
    }
end

local function monochrome()
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
end

return {
    { "catppuccin/nvim", name = "catppuccin", enabled = false },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = colorful,
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
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
        end,
    }
}
