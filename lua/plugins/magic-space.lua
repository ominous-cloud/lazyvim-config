return {
    { import = "lazyvim.plugins.extras.dap.core" },
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

            local dap = require "dap"
            local utils = require "dap.utils"
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "codelldb",
                    args = { "--port", "${port}" },
                    -- detached = false,
                }
            }
            local codelldb_launch_config = {
                name = "codelldb: Launch",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input({
                        prompt = "Path to executable: ",
                        default = vim.fn.getcwd() .. "/",
                        completion = "file",
                    })
                end,
                cwd = function()
                    return vim.fn.input({
                        prompt = "Working Directory > ",
                        default = vim.fn.getcwd() .. "/",
                        completion = "file",
                    })
                end,
                stopOnEntry = false,
                runInTerminal = false,
            }
            local codelldb_attach_config = {
                name = "codelldb: Attach to process",
                type = "codelldb",
                request = "attach",
                pid = utils.pick_process,
                args = {},
            }
            local codelldb_configs = {
                codelldb_launch_config,
                codelldb_attach_config,
            }
            dap.configurations.cpp = codelldb_configs
            dap.configurations.rust = codelldb_configs
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
