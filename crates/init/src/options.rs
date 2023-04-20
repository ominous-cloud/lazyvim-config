use nvim_oxi as oxi;

#[oxi::module]
pub fn config_options() -> oxi::Result<()> {
    oxi::api::set_option("ruler", false)?;
    oxi::api::set_option("signcolumn", "no")?;

    oxi::print!("hello world");

    oxi::api::set_option("autowrite", false)?;

    Ok(())
}
