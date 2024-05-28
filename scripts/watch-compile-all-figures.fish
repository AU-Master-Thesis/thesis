#!/usr/bin/env nix-shell
#! nix-shell -i fish -p watchexec

watchexec --clear --watch ./figures -e typ -e tex -e py ./scripts/compile-all-figures.fish
