return {
  {
    "mfussenegger/nvim-dap",
  },
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      expand_lines = false,
      layouts = {
        {
          elements = {
            { id = "breakpoints", size = 0.2 },
            { id = "stacks",    size = 0.2 },
            { id = "watches",   size = 0.2 },
            { id = "scopes",    size = 0.4 },
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
