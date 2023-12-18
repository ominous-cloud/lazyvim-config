local M = {}

local function find_root(pattern)
  return vim.fs.dirname(vim.fs.find(pattern, { upward = true })[1])
end

-- TODO: doc
local function create_lsp_autocmd(opts)
  local ft = opts.ft
  local bin = opts.cmd[1]
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = function()
      if vim.fn.executable(bin) ~= 1 then
        return true
      end
      vim.lsp.start(opts)
      return true
    end,
  })
end

function M.setup()
  create_lsp_autocmd {
    ft = "lua",
    name = "lua_ls",
    cmd = { "lua-language-server" },
    root_dir = find_root { ".git" } .. "/lua",
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  }
  create_lsp_autocmd {
    ft = "nix",
    name = "nil_ls",
    cmd = { "nil" },
    root_dir = find_root { "flake.nix", ".git" },
    settings = {
      ["nil"] = {
        formatting = {
          command = { "nixpkgs-fmt" },
        },
      },
    },
  }
  create_lsp_autocmd {
    ft = "rust",
    name = "rust_analyzer",
    cmd = { "rust-analyzer" },
    root_dir = find_root { ".git" },
    settings = {},
  }

  vim.keymap.set('n', '<space>fp', vim.diagnostic.open_float)
  vim.keymap.set('n', '[g', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']g', vim.diagnostic.goto_next)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(e)
      local opts = { buffer = e.buf }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<space>ar', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'v' }, '<space>aw', vim.lsp.buf.code_action, opts)
      vim.keymap.set({ 'n', 'v' }, '<space>cf', vim.lsp.buf.format, opts)
    end,
  })
end

return M
