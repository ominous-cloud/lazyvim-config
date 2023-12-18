use crate::{
    oxi::{
        self,
        api::{self, types::Mode},
        mlua::{
            chunk,
            prelude::{LuaFunction, LuaTable},
        },
    },
    utils::empty_function,
};

fn setup_lua(bin: &'static str, ft: &str) -> oxi::Result<()> {
    let opts = api::opts::CreateAutocmdOpts::builder()
        .patterns([ft])
        .callback(move |_| {
            let lua = oxi::mlua::lua();
            let start = lua.load("vim.lsp.start").eval::<LuaFunction>()?;
            let opts = lua
                .load(chunk! {{
                    name = $bin,
                    cmd = { $bin },
                    root_dir = "/home/houjuunue/.config/nvim/lua",
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            }
                        },
                    },
                }})
                .eval::<LuaTable>()?;
            start.call::<_, ()>(opts)?;
            Ok::<_, oxi::Error>(false)
        })
        .build();

    api::create_autocmd(["FileType"], &opts)?;
    Ok(())
}

// fn buf_map<'a>(
//     buf: &'a api::Buffer,
//     mode: Mode,
//     lhs: &str,
//     rhs: impl Fn(()) -> Result<(), api::Error>,
// ) -> oxi::Result<()> {
//     let opts = api::opts::SetKeymapOpts::builder().callback(rhs).build();
//     buf.set_keymap(mode, lhs, "", &opts)?;
//     Ok(())
// }
//
// fn setup_attach() -> oxi::Result<()> {
//     let opts = api::opts::CreateAutocmdOpts::builder()
//         .callback(move |e: oxi::Dictionary| {
//             let lua = oxi::mlua::lua();
//             let buf = api::Buffer::from(e.get("buf").ok_or("")?);
//             let n = Mode::Normal;
//             let v = Mode::VisualSelect;
//             buf_map(&buf, n, "<space>fp", |_| {
//                 Ok(lua.load("vim.diagnostic.open_float()").exec()?)
//             })?;
//             buf_map(&buf, n, "[g", |_| {
//                 Ok(lua.load("vim.diagnostic.open_float()").exec()?)
//             })?;
//             buf_map(&buf, n, "]g", |_| {
//                 Ok(lua.load("vim.diagnostic.open_float()").exec()?)
//             })?;
//             buf_map(&buf, n, "gD", |_| {
//                 Ok(lua.load("vim.diagnostic.open_float()").exec()?)
//             })?;
//             buf_map(&buf, n, "cf", |_| {
//                 Ok(lua.load("vim.lsp.buf.format()").exec()?)
//             })?;
//             buf_map(&buf, v, "cf", |_| {
//                 Ok(lua.load("vim.lsp.buf.format()").exec()?)
//             })?;
//
//             Ok::<_, oxi::Error>(false)
//         })
//         .build();
//     api::create_autocmd(["LspAttach"], &opts)?;
//     Ok(())
// }

// TODO: rewrite lsp protocol in rs in the future (why?)
pub(crate) fn load() -> oxi::Result<()> {
    let _ = empty_function();

    setup_lua("lua-language-server", "lua")?;

    Ok(())
}
