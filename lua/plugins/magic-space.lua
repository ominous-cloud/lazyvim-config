return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local Config = require "lazyvim.config"
            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

            for name, sign in pairs(Config.icons.dap) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define("Dap" .. name, {
                    text = sign[1],
                    texthl = sign[2] or "DiagnosticInfo",
                    linehl = sign[3],
                    numhl = sign[3],
                })
            end
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        opts = {
            expand_lines = false,
            layouts = {
                {
                    elements = {
                        { id = "breakpoints", size = 0.2 },
                        { id = "stacks",      size = 0.2 },
                        { id = "watches",     size = 0.2 },
                        { id = "scopes",      size = 0.4 },
                    },
                    size = 50,
                    position = "right",
                },
            },
            icons = {
                expanded = "",
                collapsed = "",
                current_frame = "",
            },
        },
    },
}
