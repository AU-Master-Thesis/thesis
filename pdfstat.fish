#!/usr/bin/env -S fish --no-config

function pdfstat -a pdf
    set -l options h/help j/json
    if not argparse $options -- $argv
        eval (status function) --help
        return 2
    end

    set -l reset (set_color normal)
    set -l red (set_color red)
    set -l green (set_color green)

    # TODO: finish error messages

    if not command --query pdftotext
        printf '%serror:%s \n' >&2
        return 1
    end

    if test (count $argv) -eq 0
        return 2
    end

    if not test -f $pdf
        return 2
    end

    if not test (path extension $pdf) = .pdf
        return 2
    end

    command pdftotext $pdf - | command wc | read lines words characters

    if set --query _flag_json
        set -l output
        set -a output (printf '{\n')
        set -a output (printf '\t"lines": %d,\n' $lines)
        set -a output (printf '\t"words": %d,\n' $words)
        set -a output (printf '\t"characters": %d\n' $characters)
        set -a output (printf '}\n')

        # printf '%s\n' $output
        if isatty stdout; and command --query jq
            printf '%s\n' $output | command jq '.'
        else
            printf '%s\n' $output
        end
    else
        printf '%slines%s:      %10d\n' $green $reset $lines
        printf '%swords%s:      %10d\n' $green $reset $words
        printf '%scharacters%s: %10d\n' $green $reset $characters
    end
end

pdfstat $argv
