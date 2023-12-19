{
  description = "nvim";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (import inputs.rust-overlay)
          ];
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            (rust-bin // {distRoot = "https://mirrors.tuna.tsinghua.edu.cn/rustup";}).stable.latest.complete
            luajit
            openssl
            libuv
            iconv
          ];
          nativeBuildInputs = with pkgs; [
            lua-language-server
            rustPlatform.bindgenHook
            pkg-config
          ];
          LIBCLANG_PATH = "${pkgs.llvmPackages_16.libclang.lib}/lib";
        };
      }
    );
}
