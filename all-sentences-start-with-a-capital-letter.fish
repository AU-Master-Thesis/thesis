#!/usr/bin/env -S fish --no-config

set -l pdf main.pdf

if test (count $argv) -gt 0
    set pdf $argv[1]
end

if not test -f $pdf
    printf '%serror%s: %s is not a file\n' (set_color red) (set_color normal) $pdf >&2
    exit 1
end

set -l matches (pdftotext $pdf - | string match --groups-only --regex --all '\. +([a-z][^.]+)')

set -l reset (set_color normal)
set -l bold (set_color --bold)
set -l italics (set_color --italics)
set -l red (set_color red)
set -l green (set_color green)
set -l yellow (set_color yellow)
set -l blue (set_color blue)
set -l cyan (set_color cyan)
set -l magenta (set_color magenta)

for m in $matches
    string split --max=1 " " $m | read --line first_word rest

    printf '%s%s%s %s\n' $red $first_word $reset $rest
end

exit (count $matches)
