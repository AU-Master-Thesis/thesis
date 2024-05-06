#!/usr/bin/env nix-shell
#! nix-shell -i fish

for f in .githooks/*
    cp $f .git/hooks/
end
