use nvim_oxi::libuv::AsyncHandle;
use tokio::sync::mpsc::UnboundedSender;

#[derive(Clone)]
pub enum Message {
    String(String),
}

impl std::convert::From<&str> for Message {
    fn from(value: &str) -> Self {
        Self::String(value.into())
    }
}

#[derive(Clone)]
pub struct BaseSender<T>
where
    T: Send + Sync + 'static,
{
    handle: Option<AsyncHandle>,
    inner: Option<UnboundedSender<T>>,
}

impl<T> BaseSender<T>
where
    T: Send + Sync + 'static,
{
    pub fn new(handle: AsyncHandle, inner: UnboundedSender<T>) -> Self {
        Self {
            handle: Some(handle),
            inner: Some(inner),
        }
    }

    pub fn _empty() -> Self {
        Self {
            handle: None,
            inner: None,
        }
    }

    // TODO: add custom error
    pub fn send(&self, message: T) -> anyhow::Result<()> {
        let (handle, inner) = match (&self.handle, &self.inner) {
            (Some(handle), Some(inner)) => (handle, inner),
            // TODO: log::info!("trigger send on empty sender")
            _ => return Ok(()),
        };

        inner.send(message)?;
        handle.send()?;
        Ok(())
    }
}

pub type Sender = BaseSender<Message>;
