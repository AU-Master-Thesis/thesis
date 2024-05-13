#!/usr/bin/env nix-shell
#! nix-shell -i fish -p fish zathura

set -l theme macchiato

set -l latest_file
set -l latest_mtime 0

for f in **.{typ,tex}
    set -l mtime (path mtime $f)
    if test $mtime -gt $latest_mtime
        set latest_mtime $mtime
        set latest_file $f
    end
end

set -l file_to_edit main.typ
if test -n $latest_file
    set file_to_edit $latest_file
end

test -f main.pdf; and zathura main.pdf >&2 >/dev/null &
disown
kitty -e typst watch --input catppuccin=$theme main.typ &
disown

nvim $file_to_edit
