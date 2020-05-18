#!/usr/bin/env bash
set -euo pipefail
PAK_MAIN="${BASH_SOURCE[0]}"
PAK_ROOT=$(dirname "$PAK_MAIN")

source "${PAK_ROOT}/commands/build.sh"
source "${PAK_ROOT}/commands/signing.sh"

function main {
    command="${1:-"help"}"
    args="${@:2}"
    case "$command" in
        build) build-command ;;
        create-cert) create-cert-command ;;
        help) help-command ;;
        *) unknown-command "$command" ;;
    esac
}

function help-command {
    printf "Help!\n"
}

function unknown-command {
    printf "Unknown command '%s'\n" "$1"
}

main "$@"
