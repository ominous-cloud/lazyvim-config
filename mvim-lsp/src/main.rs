use std::io::Write;

use {
    anyhow::Context,
    tokio::io::{AsyncBufReadExt, AsyncReadExt, AsyncWriteExt},
};

struct Client {
    _server: tokio::process::Child,
    handles: Vec<tokio::task::JoinHandle<anyhow::Result<()>>>,
}

impl Client {
    const ID_INIT: u64 = 0;

    pub fn start(cmd: std::process::Command) -> anyhow::Result<Self> {
        let mut server = tokio::process::Command::from(cmd)
            .stdin(std::process::Stdio::piped())
            .stdout(std::process::Stdio::piped())
            .stderr(std::process::Stdio::piped())
            .kill_on_drop(true)
            .spawn()?;

        let mut ts = server.stdin.take().context("take stdin")?;
        let mut rs = tokio::io::BufReader::new(server.stdout.take().context("take stdout")?);

        let (itx, mut irx) = tokio::sync::mpsc::unbounded_channel();

        let home = std::env::var("HOME")?;
        let root = format!("{}/.config/nvim/mvim-lsp/", home);
        let file = "src/main.rs";
        let init = lsp_types::InitializeParams {
            process_id: Some(u32::from(std::process::id())),
            root_uri: Some(lsp_types::Url::parse(format!("file://{}", root).as_str())?),
            ..Default::default()
        };

        let h1 = tokio::spawn(async move {
            request::<_, lsp_types::request::Initialize>(&mut ts, Self::ID_INIT, init).await?;

            irx.recv().await.unwrap();

            // do something after initialized
            let _file_url = lsp_types::Url::parse(format!("file://{}{}", root, file).as_str())?;

            anyhow::Ok(())
        });

        let h2 = tokio::spawn(async move {
            let mut headers = std::collections::HashMap::new();
            loop {
                let message = match read_message(&mut rs, &mut headers).await? {
                    Some(message) => message,
                    None => return anyhow::Ok(()),
                };
                println!("message: {}", message);
                let output: serde_json::Result<jsonrpc_core::Output> =
                    serde_json::from_str(&message);
                if let Ok(jsonrpc_core::Output::Success(suc)) = output {
                    if suc.id == jsonrpc_core::id::Id::Num(Self::ID_INIT) {
                        itx.send(())?;
                    }
                }
            }
        });

        Ok(Self {
            _server: server,
            handles: vec![h1, h2],
        })
    }
}

async fn request<T, R>(t: &mut T, id: u64, params: R::Params) -> anyhow::Result<()>
where
    T: tokio::io::AsyncWrite + std::marker::Unpin,
    R: lsp_types::request::Request,
    R::Params: serde::Serialize,
{
    if let serde_json::value::Value::Object(params) = serde_json::to_value(params)? {
        let req = jsonrpc_core::MethodCall {
            jsonrpc: Some(jsonrpc_core::Version::V2),
            method: R::METHOD.to_string(),
            params: jsonrpc_core::Params::Map(params),
            id: jsonrpc_core::Id::Num(id),
        };
        send_message(t, req).await?;
        Ok(())
    } else {
        anyhow::bail!("Invalid params");
    }
}

async fn _notify<T, R>(t: &mut T, params: R::Params) -> anyhow::Result<()>
where
    T: tokio::io::AsyncWrite + std::marker::Unpin,
    R: lsp_types::notification::Notification,
    R::Params: serde::Serialize,
{
    if let serde_json::value::Value::Object(params) = serde_json::to_value(params)? {
        let req = jsonrpc_core::Notification {
            jsonrpc: Some(jsonrpc_core::Version::V2),
            method: R::METHOD.to_string(),
            params: jsonrpc_core::Params::Map(params),
        };
        send_message(t, req).await?;
        Ok(())
    } else {
        anyhow::bail!("Invalid params")
    }
}

async fn read_message(
    reader: &mut tokio::io::BufReader<tokio::process::ChildStdout>,
    headers: &mut std::collections::HashMap<String, String>,
) -> anyhow::Result<Option<String>> {
    headers.clear();
    loop {
        let mut header = String::new();
        if reader.read_line(&mut header).await? == 0 {
            return anyhow::Ok(None);
        }
        let header = header.trim();
        if header.is_empty() {
            break;
        }
        let parts: Vec<&str> = header.split(": ").collect();
        assert_eq!(parts.len(), 2);
        headers.insert(parts[0].to_string(), parts[1].to_string());
    }
    let length = headers["Content-Length"].parse()?;
    let mut content = vec![0; length];
    reader.read_exact(&mut content).await?;
    let message = String::from_utf8(content)?;
    return anyhow::Ok(Some(message));
}

async fn send_message<T, R>(t: &mut T, req: R) -> anyhow::Result<()>
where
    T: tokio::io::AsyncWrite + std::marker::Unpin,
    R: serde::Serialize,
{
    let req = serde_json::to_string(&req)?;
    let mut buf: Vec<u8> = Vec::new();
    write!(&mut buf, "Content-Length: {}\r\n\r\n{}", req.len(), req)?;
    t.write_all(&buf).await?;
    Ok(())
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let client = Client::start(std::process::Command::new("rust-analyzer"))?;
    futures::future::join_all(client.handles).await;
    Ok(())
}
