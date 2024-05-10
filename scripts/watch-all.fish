#!/usr/bin/env nix-shell
#! nix-shell -i fish -p watchexec typst tectonic jaq jq

source ./scripts/lib.fish

# function run
#     printf '%sevaluating%s: ' $magenta $reset
#     echo $argv | fish_indent --ansi
#     eval $argv
# end

function is_wsl
    string match --quiet "*microsoft*" </proc/version
end

# set -l pids
# typst w main.typ &
# disown
# set -a pids $last_pid

# set watchexec_command watchexec
# if is_wsl
#     set watchexec_command 'watchexec.exe'
# end

# $watchexec_command --exts tex --exts typ --only-emit-events --emit-events-to json-stdio \
# watchexec -n --exts tex --exts typ --only-emit-events --emit-events-to json-stdio \
#     | command jq -r '.tags[] | select(.kind = "path").absolute' | wc -l
#     | while read --line n1 n2 f
#     # echo "f: $f"
#     test $f = null; and continue
#     printf '%sinfo%s: %s changed\n' (set_color green) (set_color normal) $f >&2
#     switch (path extension $f)
#         case .tex
#             compile-tikz-to-svg $f
#             typst c main.typ
#         case .typ
#             typst c main.typ
#     end
# end


set -l last_changed ststt # just needs to be some random non zero word

# watchexec -n --exts tex --watch ./figures --debounce 1000ms --only-emit-events --emit-events-to stdio \
watchexec -n --exts tex --exts typ --debounce 1500ms --on-busy-update do-nothing --only-emit-events --emit-events-to stdio \
    | while read line
    # read --array lines
    # for line in $lines
    if not string match --regex --groups-only '^(\w+):(\S+)$' -- $line | read --line event file
        continue
    end
    # string match --regex --quiet '^\s*$'; and continue
    # echo $line | read -d : event file
    printf '%sinfo%s: %s: %s\n' (set_color green) (set_color normal) $event $file >&2
    if not test $event = modify
        continue
    end
    if test $last_changed = $file
        continue
    end
    set last_changed $file
    set -l ext (path extension $file)
    switch $ext
        case .tex
            compile-tikz-to-svg $file
            run typst c main.typ
        case .typ
            run typst c main.typ
        case '*'
            printf '%serror%s: unknown extension %s\n' (set_color red) (set_color normal) $ext >&2
    end
    # end
end

# wait $pids

# pkill typst
