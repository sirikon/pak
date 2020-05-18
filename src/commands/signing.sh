#!/usr/bin/env bash
set -euo pipefail
source "${PAK_ROOT}/display/display.sh"
source "${PAK_ROOT}/utils/utils.sh"

configHome="${XDG_CONFIG_HOME:-"${HOME}/.config"}/pak"
localCertsFolder="${configHome}/certs/local"

function create-cert-command {
    certName="default"
    privateKeyPath="${localCertsFolder}/${certName}_private.pem"
    publicKeyPath="${localCertsFolder}/${certName}_public.pem"

    log-title "Creating certificate '${certName}'"
    mkdir -p "$localCertsFolder"

    create-private-key "${privateKeyPath}"
    log "Private key: ${privateKeyPath}"

    create-public-key "${privateKeyPath}" "${publicKeyPath}"
    log "Public key: ${publicKeyPath}"
    log "Public key MD5: $(get-publc-key-md5 ${publicKeyPath})"
}

function create-private-key {
    dest="$1"
    run-silent openssl ecparam -genkey -name secp384r1 -noout -out "${dest}"
}

function create-public-key {
    privateKeyPath="$1"; dest="$2"
    run-silent openssl ec -in "${privateKeyPath}" -pubout -out "${dest}"
}

function get-publc-key-md5 {
    publicKeyPath="$1"
    openssl pkey -in "$publicKeyPath" -pubin -pubout -outform DER | openssl md5 -c -hex | awk '{print $2}'
}

# openssl dgst -sha256 -verify public.pem -signature my_signature hello-world_1.0.0.pak
# openssl dgst -sha256 -sign private.pem -out my_signature hello-world_1.0.0.pak
