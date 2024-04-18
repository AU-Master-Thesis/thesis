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


function pdfstat -a pdf
    set -l options h/help j/json
    if not argparse $options -- $argv
        eval (status function) --help
        return 2
    end

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
        printf '%scharacters%s:      %10d\n' $green $reset $characters
        printf '%swords%s:           %10d\n' $green $reset $words
        printf '%slines%s:           %10d\n' $green $reset $lines
        set -l characters_per_normal_page 2400
        set -l estimated_pages (math "$characters / $characters_per_normal_page")
        printf '%sestimated pages%s: %s%10.2f%s (using %s characters for a normal page)\n' $green $reset $magenta $estimated_pages $reset $characters_per_normal_page
    end
end

# pdfstat $argv

set -l pdfs
if test (count $argv) -eq 0
    set pdfs **.pdf
else
    set pdfs $argv
end

set -l cyan (set_color cyan)
set -l reset (set_color normal)
set -l n (count $pdfs)
# for f in $pdfs
for i in (seq $n)
    # printf
    set -l f $pdfs[$i]
    string pad --right --char="-" --width=100 (printf '%s%s%s' $cyan $f $reset)
    pdfstat $f
    if test $i -lt $n
        echo ""
    end
end
