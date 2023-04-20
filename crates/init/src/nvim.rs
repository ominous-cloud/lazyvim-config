use nvim_oxi as oxi;

pub fn prepend(opt: &str, value: String) -> oxi::Result<()> {
    let list = oxi::api::get_option::<String>(opt)?;
    oxi::api::set_option(opt, format!("{},{}", list, value))?;
    Ok(())
}
