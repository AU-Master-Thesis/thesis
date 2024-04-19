#!/usr/bin/env -S fish --no-config

set -g options v/verbose

if not argparse $options -- $argv
    # eval (status function) --help
    return 2
end

set -g reset (set_color normal)
set -g bold (set_color --bold)
set -g italics (set_color --italics)
set -g red (set_color red)
set -g green (set_color green)
set -g yellow (set_color yellow)
set -g blue (set_color blue)
set -g cyan (set_color cyan)
set -g magenta (set_color magenta)

function color_path -a path
    set -l dirname (path dirname $path)
    set -l basename (path basename $path)
    if test $dirname = .
        printf './%s%s%s\n' $bold $basename $reset
    else
        printf '%s%s%s/%s%s%s\n' $blue $dirname $reset $bold $basename $reset
    end
end

set -l exclude_dirs journal

set -l typ_files (fd --absolute-path --exclude $exclude_dirs --extension typ)
set -l typ_files_not_included $typ_files

if set --query _flag_verbose
    for f in $typ_files
        color_path $f
    end
end

# printf ' - %s\n' $typ_files
# exit 0

set -l files_to_visit $PWD/main.typ

block --global

while test (count $files_to_visit) -gt 0
    set -l f $files_to_visit[1]
    set -e files_to_visit[1]
    # printf '%scwd%s: %s\n' $yellow $reset $PWD
    # printf '%svisit%s: %s\n' $blue $reset $f

    # set -l dirname (path dirname $f)
    # if test $dirname != $PWD
    #     pushd $dirname
    # end

    # printf 'files left to visit:\n'
    # printf ' - %s\n' $files_to_visit

    # for f in $files_to_visit
    #     color_path $f
    # end

    set -l imports (string match --regex --groups-only '^#import "([^"]+)"' < $f)
    set -l includes (string match --regex --groups-only '^#include "([^"]+)"' < $f)

    # printf 'includes: %s\n' $includes
    # exit 0


    for import in $imports
        if test (string sub --length=1 $import) = "@"
            # external file imported through the typst package manager
            if set --query _flag_verbose
                printf '%sinfo%s: skipping %s\n' (set_color green) (set_color normal) $import >&2
            end
            continue
        end

        if not contains -- $import $files_to_visit
            # resolve file path
            # set -l dirname (path $dirname)
            pushd (path dirname $f)
            # printf '%scwd%s: %s\n' $yellow $reset $PWD
            set import (path resolve $import)
            popd

            # printf '%simport%s:  %s\n' $magenta $reset $import
            set -a files_to_visit $import
        end
    end

    for include in $includes
        if not contains -- $include $files_to_visit
            pushd (path dirname $f)
            # printf '%scwd%s: %s\n' $yellow $reset $PWD
            set include (path resolve $include)
            popd
            # printf '%sinclude%s: %s\n' $red $reset $include
            set -a files_to_visit $include
        end
    end

    if contains --index -- $f $typ_files_not_included | read index
        # printf '%sdeleting%s: %s from list of visited\n' $red $reset $f

        set -e typ_files_not_included[$index]
    end

    # read input

end

if test (count $typ_files_not_included) -gt 0
    printf '%serror%s: %s%d%s typ files not included\n' $red $reset $red (count $typ_files_not_included) $reset >&2

    if command --query as-tree
        printf '%s\n' $typ_files_not_included | as-tree
    else
        for f in $typ_files_not_included
            printf ' - '
            color_path $f
        end
    end

    # printf ' - %s\n' $typ_files
    exit 1
else
    exit 0
end

# TODO: draw as a tree structure
