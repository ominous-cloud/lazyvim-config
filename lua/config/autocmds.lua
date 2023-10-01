vim.filetype.add({
    extension = {
        wgsl = "wgsl",
    },
})

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

vim.api.nvim_create_augroup("CppCommentString", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "cpp", "c",
    },
    group = "CppCommentString",
    callback = function()
        vim.bo.cms = "// %s"
    end,
})
