use nvim_oxi as oxi;

pub fn prepend(opt: &str, value: String) -> oxi::Result<()> {
    let old = oxi::api::get_option::<String>(opt)?;
    oxi::api::set_option("rtp", format!("{},{}", old, value))?;
    Ok(())
}
