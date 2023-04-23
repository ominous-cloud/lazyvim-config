vim.api.nvim_create_augroup('FrontendFileType', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'vue,typescript,typescriptreact',
    group = 'FrontendFileType',
    callback = function()
        vim.opt.shiftwidth = 2
    end,
})
