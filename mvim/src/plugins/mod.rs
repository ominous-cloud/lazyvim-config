use crate::{oxi, utils::empty_function};

pub(crate) fn load() -> oxi::Result<()> {
    let _ = empty_function();

    mvim_lsp::load()?;

    Ok(())
}
