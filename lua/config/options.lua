-- override default
vim.opt.autoread = true
vim.opt.cindent = true
vim.opt.cinkeys:remove "0#"
vim.opt.clipboard = "unnamed"
vim.opt.fillchars = "eob: ,fold: ,vert: "
vim.opt.indentkeys:remove "0#"
vim.opt.laststatus = 0
vim.opt.ruler = false
vim.opt.scrolloff = 5
vim.opt.shortmess:append "cSI"
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.showtabline = 0
vim.opt.signcolumn = "no"
vim.opt.smoothscroll = true
vim.opt.spelllang = "en,cjk"
vim.opt.termguicolors = true
vim.opt.undofile = true

if vim.fn.has "mac" then
  vim.opt.clipboard = ""
end

-- reset lazyvim
vim.opt.autowrite = false
vim.opt.completeopt = "menu,preview"
vim.opt.conceallevel = 0
vim.opt.confirm = false
vim.opt.cursorline = false
vim.opt.ignorecase = false
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.shiftwidth = 2
vim.opt.tabstop = 8
vim.opt.wildmode = "full"
vim.opt.wrap = true

vim.g.autoformat = false

-- filetypes
vim.filetype.add({
  extension = {
    wgsl = "wgsl",
  },
})

-- disable notification while spawning language server
---@param msg string Content of the notification to show to the user.
---@param level integer|nil One of the values from |vim.log.levels|.
---@param opts table|nil Optional parameters. Unused by default.
---@diagnostic disable-next-line: duplicate-set-field, unused-local
vim.notify = function(msg, level, opts)
  if level == vim.log.levels.ERROR then
    vim.api.nvim_err_writeln(msg)
  elseif level == vim.log.levels.WARN then
    local start = "Spawning language server with cmd"
    if msg:sub(1, #start) ~= start then
      vim.api.nvim_echo({ { msg, 'WarningMsg' } }, true, {})
    end
  else
    vim.api.nvim_echo({ { msg } }, true, {})
  end
end
