#!/usr/bin/env nix-shell
#! nix-shell -i fish -p hello

set -g reset (set_color normal)
set -g bold (set_color --bold)
set -g italics (set_color --italics)
set -g red (set_color red)
set -g green (set_color green)
set -g yellow (set_color yellow)
set -g blue (set_color blue)
set -g cyan (set_color cyan)
set -g magenta (set_color magenta)

set -l root $PWD/main.typ
if test (count $argv) -gt 0
    set root $argv
end

if not test -f $root
    printf '%serror%s: root %s is not a file\n' (set_color red) (set_color normal) $root >&2
end

set root (path resolve $root)

# set -l files_to_visit $PWD/main.typ
set -l files_to_visit $root
set -l visited

block --global

while test (count $files_to_visit) -gt 0
    set -l f $files_to_visit[1]
    set -e files_to_visit[1]
    set -a visited $f
    set -l includes (string match --regex --groups-only '^#include "([^"]+)"' < $f)

    for include in $includes
        if not contains -- $include $files_to_visit
            pushd (path dirname $f)
            set include (path resolve $include)
            popd
            set -a files_to_visit $include
        end
    end
end


if isatty stdout
    printf '%s\n' $visited | as-tree
else
    printf '%s\n' $visited
end

exit 0
