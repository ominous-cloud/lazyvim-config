use crate::{oxi, utils::empty_function};

pub(crate) fn load() -> oxi::Result<()> {
    let f = empty_function();
    f.call(())?;
    Ok(())
}
