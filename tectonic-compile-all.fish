#!/usr/bin/env -S fish --no-config

set -g reset (set_color normal)
set -g bold (set_color --bold)
set -g italics (set_color --italics)
set -g red (set_color red)
set -g green (set_color green)
set -g yellow (set_color yellow)
set -g blue (set_color blue)
set -g cyan (set_color cyan)
set -g magenta (set_color magenta)

set -l options o/outdir=

if not argparse $options -- $argv
    return 2
end

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

set -g outdir ./figures/out
if set --query _flag_outdir
    if test -f $_flag_outdir
        printf '%serror%s: the given --outdir <dir> (%s) is a file, not a directory 😡\n' $red $reset $_flag_outdir
    end
end

if not test -d $outdir
    printf '%sinfo%s: creating outdir at %s%s%s\n' $green $reset $blue $outdir $reset
    command mkdir -p $outdir
end

set -l t_start (date +%s)

set -l tex_document_files (command rg --pcre2-unicode --glob '*.tex' '^\\\\begin\{document\}' --files-with-matches)

if test (count $tex_document_files) -eq 0
    printf '%swarn%s: no .tex files with a `\begin{document}` line found in %s\n' $yellow $reset $PWD
    return 1
end

set -l mtime_cache_path /tmp/(status filename).cache
if not test -f $mtime_cache_path
    printf '%sinfo%s: creating mtime cache at %s%s%s\n' $green $reset $blue $mtime_cache_path $reset
    touch $mtime_cache_path
end

set -l cache
while read line
    set -a cache $line
end <$mtime_cache_path

# TODO: print duration since now
printf 'cache:\n'
printf ' - %s\n' $cache


function run
    printf '%sevaluating%s: ' $magenta $reset
    echo $argv | fish_indent --ansi
    eval $argv
end

function compile-to-svg -a document
    set -l output_pdf $outdir/(path change-extension pdf (path basename $document))
    set -l output_svg (path change-extension svg $output_pdf)
    set -l --long

    run command tectonic -X compile $document --outdir $outdir
    run command pdf2svg $output_pdf $output_svg
end

set -l new_cache
set -g delimiter '|'

for document in $tex_document_files
    set -l mtime (path mtime $document)
    set -l skip 0
    set -l in_cache 0
    for line in $cache
        echo $line | read -d "$delimiter" f cached_mtime
        # echo "f: $f"
        # echo "cached_mtime: $cached_mtime"
        if test $f = $document
            set in_cache 1
            if test $mtime -eq $cached_mtime
                set skip 1
            end
            set -a new_cache "$f$delimiter$mtime"
        end
    end

    if test $in_cache -eq 0
        set -a new_cache "$document$delimiter$mtime"
    end

    if test $skip -eq 1
        printf '%sinfo%s: skipping %s as it has not been modified since last compile\n' $green $reset $document
        continue
    end


    compile-to-svg $document &
    # command tectonic -X compile $document --outdir $outdir &
    # disown
end

printf '%sinfo%s: waiting on compiles to finish ...\n' $green $reset
wait

printf '%sinfo%s: updating mtime cache ...\n' $green $reset

printf '%s\n' $new_cache >$mtime_cache_path

set -l t_end (date +%s)
set -l duration (math "$t_end - $t_start")

printf '%sinfo%s: all done, took %s%s%s seconds\n' $green $reset $blue $duration $reset
