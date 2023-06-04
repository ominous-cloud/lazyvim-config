-- local postfix = require("luasnip.extras.postfix").postfix

local function cpio()
    local file = io.open(vim.fn.stdpath("config") .. "/snippets/rust/cpio.rs", "r")
    local content = file and file:read "*all" or "// 404"
    if file then file:close() end
    content = string.gsub(content, "%[", "[[")
    content = string.gsub(content, "]", "]]")
    return content
end

return {
    -- template
    s("cpio", fmt(cpio(), {}, { delimiters = "[]" })),
}, {
    -- autosnippets
}
