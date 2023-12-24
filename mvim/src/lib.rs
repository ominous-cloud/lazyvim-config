pub use nvim_oxi as oxi;

mod config;
mod init;
mod plugins;
mod utils;

#[oxi::module]
pub fn mvim() -> oxi::Result<oxi::Dictionary> {
    Ok(oxi::Dictionary::from_iter([(
        "setup",
        oxi::Function::from_fn::<_, oxi::Error>(init::setup),
    )]))
}
