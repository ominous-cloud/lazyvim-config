use crate::{config, oxi, plugins};

pub(crate) fn setup(_: ()) -> oxi::Result<()> {
    config::setup()?;
    plugins::load()?;

    Ok(())
}
