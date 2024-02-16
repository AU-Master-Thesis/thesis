{
  description = "Computer Engineering Master Thesis";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in
      with pkgs; {
        devShells.default = mkShell {
          buildInputs = [
            typst
            typstfmt
            typst-lsp
            hayagriva
            graphviz
            python3
            just
            ltex-ls # languagetool lsp
            typos
            yq-go
            jq
            taplo
          ];
        };
      });
}
