#!/usr/bin/env nix-shell
#! nix-shell -i fish -p hello

for f in .githooks/*
    cp $f .git/hooks/
end
