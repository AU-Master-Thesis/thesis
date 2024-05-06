#!/usr/bin/env nix-shell
#! nix-shell -i fish -p hello

set -l reset (set_color normal)
set -l bold (set_color --bold)
set -l italics (set_color --italics)
set -l red (set_color red)
set -l green (set_color green)
set -l yellow (set_color yellow)
set -l blue (set_color blue)
set -l cyan (set_color cyan)
set -l magenta (set_color magenta)

set -l svgs (path resolve ./figures/out/*.svg img/*.svg)

set -l typ_files (./scripts/includes.fish ./main.typ)

set -l svgs_used

block --global

for f in $typ_files
    set -l images (string match --regex --groups-only '#?image\("([^"]+)"\)' < $f)
    set -l images_resolved

    pushd (path dirname $f)
    for img in $images
        set -a images_resolved (path resolve $img)
    end
    popd

    for img in $images_resolved
        if not contains -- $img $svgs_used
            set -a svgs_used $img
        end
    end
end

set -l n_svgs_not_used 0

for f in $svgs
    set -l f_relative (string replace $PWD '.' -- $f)

    if contains -- $f $svgs_used
        printf '[%s✓%s] %s%s%s\n' $green $reset $green $f_relative $reset
    else
        printf '[%s✘%s] %s%s%s 😡\n' $red $reset $red $f_relative $reset
        set n_svgs_not_used (math "$n_svgs_not_used + 1")
    end
end

exit $n_svgs_not_used
