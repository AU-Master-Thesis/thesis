#!/usr/bin/env nix-shell
#! nix-shell -i fish -p typst jaq


set -g reset (set_color normal)
set -g bold (set_color --bold)
set -g italics (set_color --italics)
set -g red (set_color red)
set -g green (set_color green)
set -g yellow (set_color yellow)
set -g blue (set_color blue)
set -g cyan (set_color cyan)
set -g magenta (set_color magenta)

set -l query "selector(heading).or(selector(figure)).or(selector(metadata)).or(selector(math.equation))"
set -l labels (typst query main.typ --field label $query | jaq -r '.[]' | string sub --start=2 --end=-1)
set -l labels_used

set -l files (./scripts/includes.fish ./main.typ)
# TODO: handle '#ref("label")' | '#ref(<label>)' syntax
set -l regexp "@($(string join '|' -- $labels))"

for f in $files
    set -l matches (string match --regex --groups-only $regexp < $f)
    for m in $matches
        if not contains -- $m $labels_used
            set -a labels_used $m
        end
    end
end

set -l n_references_not_used 0

for l in $labels
    if contains -- $l $labels_used
        printf '[%s✓%s] %s%s%s\n' $green $reset $green $l $reset
    else
        printf '[%s✘%s] %s%s%s not used 😡\n' $red $reset $red $l $reset
        set n_references_not_used (math "$n_references_not_used + 1")
    end
end

exit $n_references_not_used
