#!/usr/bin/env -S fish --no-config


function run
    printf '%sevaluating%s: ' $magenta $reset
    echo $argv | fish_indent --ansi
    eval $argv
end

function is_wsl
    string match --quiet "*microsoft*" < /proc/version
end

set watchexec_command 'watchexec'
if is_wsl
    set watchexec_command 'watchexec.exe'
end

set typst_command 'typst w main.typ &'
if is_wsl
    set typst_command 'watchexec.exe --clear -e typ typst c main.typ'
end

set -l pids
run "$watchexec_command --exts tex ./tectonic-compile-all.fish &"
set -a pids $last_pid
disown
run "$typst_command"
set -a pids $last_pid
disown

# run watchexec --watch sections/ --watch *.typ --exts typ typst c main.typ

function __ctrl_c_handler --on-signal INT KILL
    exit 0
end

echo "pids: $pids"

# wait
