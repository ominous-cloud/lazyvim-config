use nvim_oxi as oxi;
use oxi::api::opts::OptionValueOptsBuilder;

#[oxi::module]
pub fn config_options() -> oxi::Result<()> {
    oxi::api::set_option("signcolumn", "no")?;

    oxi::api::set_option("autowrite", false)?;

    Ok(())
}
