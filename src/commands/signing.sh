#!/usr/bin/env bash
set -euo pipefail
source "${PAK_ROOT}/display/display.sh"

configHome="${XDG_CONFIG_HOME:-"${PWD}/.config/pak"}"
localSignaturesFolder="${configHome}/signatures/local"

function create-signature-command {
    signatureName="default"
    privateKeyPath="${localSignaturesFolder}/${signatureName}_private.pem"
    publicKeyPath="${localSignaturesFolder}/${signatureName}_public.pem"

    log-title "Creating signature '${signatureName}'"
    mkdir -p "$localSignaturesFolder"
    openssl ecparam -genkey -name secp384r1 -noout -out "${privateKeyPath}"
    log "Private key: ${privateKeyPath}"
    openssl ec -in "${privateKeyPath}" -pubout -out "${publicKeyPath}"
    log "Public key: ${publicKeyPath}"
}

# openssl dgst -sha256 -verify public.pem -signature my_signature hello-world_1.0.0.pak
# openssl dgst -sha256 -sign private.pem -out my_signature hello-world_1.0.0.pak
