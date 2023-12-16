use crate::{config, plugins, oxi};

pub(crate) fn setup(_: ()) -> oxi::Result<()> {
    config::setup()?;
    plugins::lsp::load()?;
    
    Ok(())
}