{
  description = "nvim";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustc
            cargo
            clippy
            rustfmt
            rust-analyzer
            openssl
            luajit
          ];
          nativeBuildInputs = with pkgs; [
            rustPlatform.bindgenHook
            pkg-config
          ];
          LIBCLANG_PATH = "${pkgs.llvmPackages_16.libclang.lib}/lib";
        };
      }
    );
}
