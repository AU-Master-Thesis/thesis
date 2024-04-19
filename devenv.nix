{pkgs, ...}: {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
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
    fd
    bat
    ripgrep
    gcc
    git
  ];

  # https://devenv.sh/scripts/
  scripts.hello.exec = "echo hello from $GREET";

  enterShell = ''
    # hello
    # ${pkgs.typst}/bin/typst --version
    # git --version
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep "2.42.0"
  '';

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/languages/
  # languages.nix.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    shellcheck.enable = true;
    alejandra.enable = true;
    check-added-large-files.enable = true;
    check-executables-have-shebangs.enable = true;
    check-merge-conflicts.enable = true;
    chktex.enable = true;
    commitizen.enable = true;
    end-of-file-fixer.enable = true;
    lacheck.enable = true;
    latexindent.enable = true;
    trim-trailing-whitespace.enable = true;
    typos.enable = true;
    typstfmt.enable = true;

    all-typ-files-used = {
      enable = true;
      name = "all typ files used in main.typ";
      entry = "./all-typ-files-included.fish";
      files = "\\.typ$";
      excludes = ["sections/.*\\.typ"];
      pass_filenames = false;
    };

    typ-files-compiles = {
      enable = true;
      name = "typ file compiles";
      entry = "${pkgs.typst}/bin/typst compile";
      files = "\\.typ$";
      pass_filenames = true;
    };
  };

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
