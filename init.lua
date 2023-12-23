local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

local function load_plugins()
  vim.opt.rtp:prepend(lazypath)
  require "lazy".setup {
    {
      "LazyVim/LazyVim",
      priority = 10000,
      { import = "config.lazy" },
      { import = "lazyvim.plugins" },
    },
    { import = "plugins" },
  }
end

if not vim.uv.fs_stat(lazypath) then
  local cmd = vim.fn.split([[
    git clone
      --filter blob:none
      https://github.com/folke/lazy.nvim.git
      --branch stable
  ]] .. lazypath)
  vim.system(cmd, {}, function()
    print "Lazy is cloned. Restart to reload."
  end)
else
  load_plugins()
end
