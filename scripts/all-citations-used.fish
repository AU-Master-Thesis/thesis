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

set -l citations (string match --regex --groups-only '^([^ :]+):\s*$' < ./references.yaml)

# printf '%s\n' $citations

set -l citations_used_count
set -l citations_used

set -l files (./scripts/includes.fish ./main.typ)

set -l regexp "@($(string join '|' -- $citations))"

for f in $files
    set -l matches (string match --regex --groups-only --all $regexp <$f)

    for m in $matches
        if not contains -- $m $citations_used
            set -a citations_used $m
        end
    end
end

# printf ' - %s\n' $citations_used

set -l n_citations_not_used 0

for ref in $citations
    if contains -- $ref $citations_used
        printf '[%s✓%s] %s%s%s\n' $green $reset $green $ref $reset
    else
        printf '[%s✘%s] %s%s%s not used 😡\n' $red $reset $red $ref $reset
        set n_citations_not_used (math "$n_citations_not_used + 1")
    end
end

exit $n_citations_not_used



# rg "@($(string join '|' -- $citations))" --glob '*.typ' --stats
