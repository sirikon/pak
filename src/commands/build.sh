#!/usr/bin/env bash
set -euo pipefail
source "${PAK_ROOT}/display/display.sh"

pakFilePath="${PWD}/pak.json"

function build-command {
    log-title "Checking pak requirements"
    log "Work directory: $(pwd)"
    verify-pak-file
    log-title "Building pak archive"
    build-pak-archive
}

function verify-pak-file {
    verify-pak-file-exists
    verify-pak-file-required-fields
}

function build-pak-archive {
    pakArchivePath="$PWD/$(get-pak-archive-name).pak"
    if [ -f "$pakArchivePath" ]; then
        log "Pak archive already exists in target path. Removing"
        rm $pakArchivePath
    fi
    tar --create --gzip --file "$pakArchivePath" -C "$PWD" *
    log "Pak archive created in $pakArchivePath"
}

function verify-pak-file-exists {
    if [ -f "$pakFilePath" ]; then
        log "pak.json found"
    else
        log-error "pak.json not found in '$pakFilePath'"
        exit 1
    fi
}

function verify-pak-file-required-fields {
    requiredFields=".name .version"
    pakFile=$(cat $pakFilePath | jq -cM)

    log "Required fields"
    for requiredField in $requiredFields
    do
        value=$(printf "%s" "$pakFile" | jq -M "${requiredField}")
        if [ "$value" = 'null' ]; then
            log-error "${requiredField} is missing in pak.json"
        else
            log "${requiredField} -> ${value}"
        fi
    done
}

function get-pak-archive-name {
    pakFile=$(cat $pakFilePath | jq -cM)
    pakName=$(printf "%s" "$pakFile" | jq -r '.name')
    pakVersion=$(printf "%s" "$pakFile" | jq -r '.version')
    printf "${pakName}_${pakVersion}"
}
