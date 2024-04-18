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
            watchexec
            pdf2svg
            typst-lsp
            tectonic
            pdf2svg
            hayagriva
            graphviz
            python3
            # poppler-utils
            poppler_utils # pdf utilities

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
