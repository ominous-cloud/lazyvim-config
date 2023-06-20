local opts = {
    noremap = true,
    silent = true,
}

vim.keymap.set("n", "<space>fh", ":bp<cr>", opts)
vim.keymap.set("n", "<space>fl", ":bn<cr>", opts)
vim.keymap.set("n", "<space>ff", ":e#<cr>", opts)
-- vim.keymap.set("n", "<space>fd", ":bp | bd #<cr>", opts)
vim.keymap.set("c", "<c-a>", "<c-b>", opts)
