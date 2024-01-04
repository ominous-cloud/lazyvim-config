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

vim.api.nvim_create_augroup("CustomTexNewMathZone", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.tex" },
  group = "CustomTexNewMathZone",
  callback = function()
    vim.iter({
      "align",
      "flalign",
      "multline",
      "gather",
    }):each(function(name)
      vim.fn.TexNewMathZone("E", name, 1)
    end)
  end,
})
