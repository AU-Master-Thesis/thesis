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

set -l references (string match --regex --groups-only '^([^ :]+):\s*$' < ./references.yaml)

# printf '%s\n' $references

set -l references_used_count
set -l references_used

set -l files (./includes.fish ./main.typ)

set -l regexp "@($(string join '|' -- $references))"

for f in $files
    set -l matches (string match --regex --groups-only --all $regexp <$f)

    for m in $matches
        if not contains -- $m $references_used
            set -a references_used $m
        end
    end
end

# printf ' - %s\n' $references_used

set -l n_references_not_used 0

for ref in $references
    if contains -- $ref $references_used
        printf '[%s✓%s] %s%s%s\n' $green $reset $green $ref $reset
    else
        printf '[%s✘%s] %s%s%s not used 😡\n' $red $reset $red $ref $reset
        set n_references_not_used (math "$n_references_not_used + 1")
    end
end

exit $n_references_not_used



# rg "@($(string join '|' -- $references))" --glob '*.typ' --stats
