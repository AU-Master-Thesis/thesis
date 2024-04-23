#!/usr/bin/env -S fish --no-config

for f in .githooks/*
    cp $f .git/hooks/
end
