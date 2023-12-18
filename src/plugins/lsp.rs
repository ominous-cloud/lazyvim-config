use crate::{oxi, utils::empty_function};

// TODO: rewrite lsp protocol in rs in the future (why?)
pub(crate) fn load() -> oxi::Result<()> {
    let _ = empty_function();

    Ok(())
}
