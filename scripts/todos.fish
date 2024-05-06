#!/usr/bin/env nix-shell
#! nix-shell -i fish -p ripgrep

rg --pcre2-unicode --glob '*.typ' '^#todo'
