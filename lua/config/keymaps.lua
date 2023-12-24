vim.keymap.del("v", "<")
vim.keymap.del("v", ">")

vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set({ "n", "v" }, "L", "$")
vim.keymap.set({ "n", "v" }, "M", "%")

vim.api.nvim_create_user_command("Trans", "'<'>!proxychains4 -q trans :zh -b", {})
