use crate::oxi;

pub fn empty_function() -> oxi::Function<(), ()> {
    return oxi::Function::from_fn(|()| Ok::<_, oxi::Error>(()));
}
