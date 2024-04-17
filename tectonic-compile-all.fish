#!/usr/bin/env -S fish --no-config


set -l reset (set_color normal)
set -l bold (set_color --bold)
set -l italics (set_color --italics)
set -l red (set_color red)
set -l green (set_color green)
set -l yellow (set_color yellow)
set -l blue (set_color blue)
set -l cyan (set_color cyan)
set -l magenta (set_color magenta)


set -l deps rg tectonic

for d in $deps
    command --query $d; and continue
    printf '%serror%s: %s is not installed\n' $red $reset $d
    exit 2
end


if test $PWD = $HOME
    printf '%swarn%s: not a good idea to use ripgrep in \$HOME! 😡\n' $yellow $reset
    exit 1
end

set -l t_start (date +%s)

set -l tex_document_files (command rg --pcre2-unicode --glob '*.tex' '^\\\\begin\{document\}' --files-with-matches)

for f in $tex_document_files
    command tectonic -X compile $f &
    # disown
end

printf '%sinfo%s: waiting on compiles to finish ...\n' $green $reset
wait


set -l t_end (date +%s)
set -l duration (math "$t_end - $t_start")

printf '%sinfo%s: all done, took %s%s%s seconds\n' $green $reset $blue $duration $reset
