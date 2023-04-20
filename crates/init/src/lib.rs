mod ffi;
mod keymaps;
mod lazy;
mod macros;
mod nvim;
mod options;
mod plugins;

use nvim_oxi as oxi;

#[oxi::module]
pub fn init() -> oxi::Result<()> {
    lazy::setup()?;
    plugins::setup()?;
    Ok(())
}
