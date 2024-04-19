#!/usr/bin/env -S fish --no-config


function run
    printf '%sevaluating%s: ' $magenta $reset
    echo $argv | fish_indent --ansi
    eval $argv
end


set -l pids
run 'watchexec --exts tex ./tectonic-compile-all.fish &'
set -a pids $last_pid
disown
run 'typst w main.typ &'
set -a pids $last_pid
disown

# run watchexec --watch sections/ --watch *.typ --exts typ typst c main.typ

function __ctrl_c_handler --on-signal INT KILL
    exit 0
end

echo "pids: $pids"

# wait
