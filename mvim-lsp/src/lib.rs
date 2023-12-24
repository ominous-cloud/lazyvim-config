mod channel;
mod client;

use nvim_oxi as oxi;
use oxi::libuv::AsyncHandle;
use tokio::sync::mpsc::unbounded_channel;

use crate::channel::{Message, Sender};
use crate::client::Client;

/// Entry point
pub fn load() -> oxi::Result<()> {
    let (tx, mut cx) = unbounded_channel::<Message>();
    let handle = AsyncHandle::new(move || {
        let message = cx
            .blocking_recv()
            .expect("unable to receive from another thread");
        oxi::schedule(move |_| {
            match message {
                Message::String(result) => oxi::print!("receive from lsp: {}", result),
            }
            Ok(())
        });
        Ok::<_, oxi::Error>(())
    })?;

    std::thread::spawn(move || {
        run(Sender::new(handle, tx))?;
        anyhow::Ok(())
    });

    Ok(())
}

// TODO: find a tool to log and debug
#[tokio::main]
async fn run(tx: Sender) -> anyhow::Result<()> {
    let pwd = format!("{}/.config/mvim/", std::env::var("HOME")?);
    let client = Client::start(tokio::process::Command::new("rust-analyzer"), pwd, tx).await?;
    for f in client.handles.into_iter() {
        f.await??;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use crate::channel::Sender;
    use crate::client::Client;

    #[tokio::test]
    async fn test_run() {
        let pwd = format!("{}/.config/mvim/", std::env::var("HOME").unwrap());
        let client = Client::start(
            tokio::process::Command::new("rust-analyzer"),
            pwd,
            Sender::_empty(),
        )
        .await
        .unwrap();

        for f in client.handles.into_iter() {
            f.await.unwrap().unwrap();
        }
    }
}
