vim.api.nvim_create_augroup("TwoSpaceFileType", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "vue", "typescript", "typescriptreact",
        "nix",
    },
    group = "TwoSpaceFileType",
    callback = function()
        vim.opt.shiftwidth = 2
    end,
})
