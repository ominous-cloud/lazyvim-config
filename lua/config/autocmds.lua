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
