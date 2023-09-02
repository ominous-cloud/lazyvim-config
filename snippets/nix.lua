-- local postfix = require("luasnip.extras.postfix").postfix

return {
    s("flake", fmt([[
        {
          inputs = {
            nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
          };

          outputs = { nixpkgs, ... }:
            let
              system = "x86_64-linux";
              pkgs = import nixpkgs {
                inherit system;
              };
            in
            {
              devShells.${system} = {
                default = pkgs.mkShell {
                  buildInputs = with pkgs; [
                    <>
                  ];
                };
              };
            };
        }
    ]], {
        i(1, "gcc"),
    }, {
        delimiters = "<>"
    })),
}, {
    -- autosnippets
}
