use crate::oxi;

mod options;

pub(crate) fn setup() -> oxi::Result<()> {
    options::setup()?;

    Ok(())
}
