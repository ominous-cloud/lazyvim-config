vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "no"
vim.opt.cursorline = false
vim.opt.ruler = false
vim.opt.wrap = true
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.showtabline = 0

vim.opt.conceallevel = 0

vim.opt.ignorecase = false
vim.opt.completeopt = "menu,preview"
vim.opt.wildmode = "full"

vim.opt.shiftwidth = 4
vim.opt.tabstop = 8
vim.g.editorconfig = true

vim.opt.autowrite = false
vim.opt.confirm = false
vim.opt.clipboard = "unnamed"

-- vim.opt.guicursor = {
--     "n-v-c-sm:hor20-Cursor/lCurosr",
--     "i-ci-ve:ver25-Cursor/lCursor",
--     "r-cr-o:hor20-Cursor/lCursor",
-- }

vim.filetype.add({
    extension = {
        wgsl = "wgsl",
    },
})

--- @diagnostic disable-next-line: duplicate-set-field, unused-local
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
