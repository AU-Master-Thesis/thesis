{pkgs, ...}: {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    typst
    typstfmt
    tinymist
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
    # tree
    as-tree
    just
    fish
    typos
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
    chktex.enable = false;
    commitizen.enable = true;
    end-of-file-fixer.enable = true;
    lacheck.enable = false;
    latexindent.enable = false;
    trim-trailing-whitespace.enable = true;
    typos.enable = true;
    # _typos = {
    #   enable = true;
    #   entry = "${pkgs.typos}/bin/typos --config typos.toml";
    # };
    typstfmt.enable = false;

    all-typ-files-used = {
      enable = true;
      name = "all typ files used in main.typ";
      entry = "./all-typ-files-included.fish";
      files = "\\.typ$";
      excludes = ["sections/.*\\.typ"];
      pass_filenames = false;
    };

    # typ-files-compiles = {
    main-typ-compiles = {
      enable = true;
      name = "typ file compiles";
      entry = "${pkgs.typst}/bin/typst compile --root . ";
      # files = "\\.typ$";
      excludes = ["sections/.*\\.typ"];
      files = "./main.typ";
      pass_filenames = true;
    };

    all-references-used = {
      enable = true;
      name = "all references used";
      entry = "./all-references-used.fish ./main.typ";
      # files = "\\.typ$";
      excludes = ["sections/.*\\.typ"];
      files = "./main.typ";
      pass_filenames = false;
    };

    all-acronyms-used = {
      enable = true;
      name = "all acronyms used";
      entry = "./all-acronyms-used.fish ./main.typ";
      # files = "\\.typ$";
      excludes = ["sections/.*\\.typ"];
      files = "./main.typ";
      pass_filenames = false;
    };

    fish = {
      enable = true;
      name = "fish scripts syntactically correct";
      entry = "${pkgs.fish}/bin/fish --no-execute";
      # types = ["files" "fish"];
      files = "\\.fish$";
      pass_filenames = true;
    };

    fish_indent = {
      enable = true;
      name = "format fish files";
      entry = "${pkgs.fish}/bin/fish_indent --check";
      files = "\\.fish$";
      # types = ["files" "fish"];
      pass_filenames = true;
    };
  };

  devcontainer.enable = true;
  difftastic.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
