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

set -l acronyms (string match --regex --groups-only 'acronym: (\S+)$' < acronyms.yaml)

set -l acronyms_used

set -l files (./includes.fish ./main.typ)

set -l regexp "#(acr|acrpl)\(\"($(string join '|' -- $acronyms))\"\)"

for f in $files
    set -l matches (string match --regex --groups-only --all $regexp <$f | while read --line _fn acronym; echo $acronym; end)

    for m in $matches
        if not contains -- $m $acronyms_used
            set -a acronyms_used $m
        end
    end
end

set -l n_acronyms_not_used 0

for ac in $acronyms
    if contains -- $ac $acronyms_used
        printf '[%s✓%s] %s%s%s\n' $green $reset $green $ac $reset
    else
        printf '[%s✘%s] %s%s%s not used 😡\n' $red $reset $red $ac $reset
        set n_acronyms_not_used (math "$n_acronyms_not_used + 1")
    end
end

exit $n_acronyms_not_used
