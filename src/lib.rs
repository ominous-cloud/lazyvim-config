use nvim_oxi::{self as oxi, Dictionary, Function};

#[oxi::module]
pub fn config() -> oxi::Result<Dictionary> {
    Ok(Dictionary::from_iter([(
        "setup",
        Function::from_fn::<_, oxi::Error>(move |()| {
            oxi::print!("Looks like it's going to be a fun night.");
            Ok(())
        }),
    )]))
}
