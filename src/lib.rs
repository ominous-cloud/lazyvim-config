pub use nvim_oxi as oxi;
use nvim_oxi::{Dictionary, Function};

mod init;
mod config;
mod plugins;
mod utils;

#[oxi::module]
pub fn mvim() -> oxi::Result<Dictionary> {
    Ok(Dictionary::from_iter([(
        "setup",
        Function::from_fn::<_, oxi::Error>(init::setup),
    )]))
}
