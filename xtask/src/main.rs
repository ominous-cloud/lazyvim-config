use std::{
    ffi::OsStr,
    path::{Path, PathBuf},
    process::{exit, Command},
};

use clap::{command, Parser, Subcommand};

type AnyError = Box<dyn std::error::Error>;

#[cfg(target_os = "linux")]
const CDYLIB_FILE: &str = "mvim.so";

#[cfg(target_os = "macos")]
const CDYLIB_FILE: &str = "libmvim.dylib";

const RUNTIME_SO_FILE: &str = "mvim.so";

#[derive(Debug, Parser)]
#[command(name = "xtask")]
#[command(about = "Just a command runner", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Debug, Subcommand)]
enum Commands {
    #[command(about = "Build release library and copy output to runtime path")]
    Release,
    #[command(about = "Build debug library")]
    Debug,
    #[command(about = "clean library files in runtime path")]
    Clean,
}

fn main() {
    if let Err(e) = run(Cli::parse()) {
        eprintln!("{}", e);
        exit(-1);
    }
}

fn run(args: Cli) -> Result<(), AnyError> {
    match args.command {
        Commands::Debug => debug()?,
        Commands::Release => release()?,
        Commands::Clean => clean()?,
    }
    Ok(())
}

fn debug() -> Result<(), AnyError> {
    cargo_build::<_, &str>([])?;
    Ok(())
}

fn release() -> Result<(), AnyError> {
    cargo_build(&["--release"])?;
    let rtp = runtime_path();
    std::fs::create_dir_all(&rtp)?;
    std::fs::copy(
        &project_root().join("target/release").join(CDYLIB_FILE),
        &rtp.join(RUNTIME_SO_FILE),
    )?;
    Ok(())
}

fn clean() -> Result<(), AnyError> {
    std::fs::remove_file(runtime_path().join(RUNTIME_SO_FILE))?;
    Ok(())
}

fn cargo_build<I, S>(args: I) -> Result<(), AnyError>
where
    I: IntoIterator<Item = S>,
    S: AsRef<OsStr>,
{
    let status = Command::new("cargo")
        .arg("build")
        .args(args)
        .current_dir(project_root())
        .status()?;

    if !status.success() {
        Err("cargo build failed")?;
    }

    Ok(())
}

fn project_root() -> PathBuf {
    Path::new(&env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(1)
        .unwrap()
        .to_path_buf()
}

fn runtime_path() -> PathBuf {
    project_root().join("lua")
}
