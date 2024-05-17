#!/usr/bin/env nix-shell
#! nix-shell -i fish -p typst jaq ripgrep tectonic

set -g reset (set_color normal)
set -g bold (set_color --bold)
set -g italics (set_color --italics)
set -g red (set_color red)
set -g green (set_color green)
set -g yellow (set_color yellow)
set -g blue (set_color blue)
set -g cyan (set_color cyan)
set -g magenta (set_color magenta)

source ./scripts/lib.fish

set -l options o/outdir=

if not argparse $options -- $argv
    return 2
end

set -l deps rg tectonic # sqlite3

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

# echo "tex_document_files: $tex_document_files"

if test (count $tex_document_files) -eq 0
    printf '%swarn%s: no .tex files with a `\begin{document}` line found in %s\n' $yellow $reset $PWD
    return 1
end

# set -l tex_include_files ./figures/include/*.tex
set -l tex_include_files figures/include/*.tex

set -l figure_mtime_cache_path /tmp/(path basename (status filename)).cache
if not test -f $figure_mtime_cache_path
    printf '%sinfo%s: creating figure mtime cache at %s%s%s\n' $green $reset $blue $figure_mtime_cache_path $reset
    touch $figure_mtime_cache_path
end

set -l include_mtime_cache_path /tmp/(path basename (status filename)).include.cache
if not test -f $include_mtime_cache_path
    printf '%sinfo%s: creating include mtime cache at %s%s%s\n' $green $reset $blue $include_mtime_cache_path $reset
    touch $include_mtime_cache_path
end

set -l include_cache
while read line
    set -a include_cache $line
end <$include_mtime_cache_path

set -l figure_cache
while read line
    set -a figure_cache $line
end <$figure_mtime_cache_path

function color_path -a path
    set -l dirname (path dirname $path)
    set -l basename (path basename $path)
    if test $dirname = .
        printf './%s%s%s' $bold $basename $reset
    else
        printf '%s%s%s/%s%s%s' $blue $dirname $reset $bold $basename $reset
    end
end

set -g delimiter '|'

set -l now (date +%s)

printf 'figure mtime cache:\n'
for line in $figure_cache
    echo $line | read -d $delimiter f timestamp
    # color_path $f
    set -l n (string length $f)
    set -l W 70
    set -l seconds_since (math "$now - $timestamp")
    printf ' - %s%s | mtime: %s%s%s seconds ago\n' (color_path $f) (string repeat --count (math "$W - $n") ' ') $yellow $seconds_since $reset
end
echo

printf 'include mtime cache:\n'
for line in $include_cache
    echo $line | read -d $delimiter f timestamp
    # color_path $f
    set -l n (string length $f)
    set -l W 70
    set -l seconds_since (math "$now - $timestamp")
    printf ' - %s%s | mtime: %s%s%s seconds ago\n' (color_path $f) (string repeat --count (math "$W - $n") ' ') $yellow $seconds_since $reset
end
echo


function run
    printf '%sevaluating%s: ' $magenta $reset
    echo $argv | fish_indent --ansi
    eval $argv
end

function compile-tikz-to-svg -a document
    set -l output_pdf $outdir/(path change-extension pdf (path basename $document))
    set -l output_svg (path change-extension svg $output_pdf)
    set -l --long

    run command tectonic -X compile $document --outdir $outdir
    run command pdf2svg $output_pdf $output_svg
end

set -l new_include_cache
set -l recompile_all_figures 0

for document in $tex_include_files
    set -l mtime (path mtime $document)

    set -l in_cache 0

    for line in $include_cache
        echo $line | read -d "$delimiter" f cached_mtime
        if test $f = $document
            set in_cache 1
            if test $mtime -gt $cached_mtime
                set recompile_all_figures 1
            end
            set -a new_include_cache "$f$delimiter$mtime"
        end
    end

    if test $in_cache -eq 0
        set -a new_include_cache "$document$delimiter$mtime"
    end
end

if test $recompile_all_figures -eq 1
    printf '%s--- recompiling all figures ---%s\n' $yellow $reset
end

set -l new_figure_cache

for document in $tex_document_files
    set -l mtime (path mtime $document)
    set -l skip 0
    set -l in_cache 0
    for line in $figure_cache
        echo $line | read -d "$delimiter" f cached_mtime
        if test $f = $document
            set in_cache 1
            if test $mtime -eq $cached_mtime
                set skip 1
            end
            set -a new_figure_cache "$f$delimiter$mtime"
        end
    end

    if test $in_cache -eq 0
        set -a new_figure_cache "$document$delimiter$mtime"
    end

    if test $recompile_all_figures -eq 1
        printf '%sinfo%s: recompiling %s%s%s\n' $green $reset (color_path $document) $reset
    else if test $skip -eq 1
        printf '%sinfo%s: skipping %s%s\n' $green $reset (color_path $document) $reset
        continue
    end

    compile-tikz-to-svg $document &
end

printf '%sinfo%s: waiting on compiles to finish ...\n' $green $reset
wait

# pushd figures
for typ in figures/*.typ
    test $typ = figures/template.typ; and continue
    set -l output (path change-extension svg (path basename $typ))
    run typst c --format=svg --root $PWD $typ $outdir/$output
end

printf '%sinfo%s: updating figure mtime cache ...\n' $green $reset
printf '%s\n' $new_figure_cache >$figure_mtime_cache_path

printf '%sinfo%s: updating include mtime cache ...\n' $green $reset
printf '%s\n' $new_include_cache >$include_mtime_cache_path

set -l t_end (date +%s)
set -l duration (math "$t_end - $t_start")

printf '%sinfo%s: all done, took %s%s%s seconds\n' $green $reset $blue $duration $reset
