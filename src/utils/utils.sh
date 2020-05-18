#!/usr/bin/env bash
set -euo pipefail
source "${PAK_ROOT}/display/display.sh"

function run-silent {
    set +e
    output=$("$@" 2>&1)
    result=$?
    set -e
    if [ "$result" -gt "0" ]; then
        log-error "Error while running command:"
        log-error "$*"
        printf "%s\n" "$output"
        exit "$result"
    fi
}
