#!/usr/bin/env bash
set -euo pipefail
cd $(dirname ${BASH_SOURCE[0]})
source ./src/display/display.sh

TEMP_FOLDER="/tmp/pak-installation"
TOOL_NAME="pak"
TOOL_PATH="/usr/local/bin/${TOOL_NAME}"

function main {
    log-title "Ensuring sudo access"
    sudo -v
    log-sep
    
    mkdir -p ${TEMP_FOLDER}

    log-title "Installing required packages"
    sudo apt-get install curl gettext-base jq
    log-sep

    log-title "Installing ${TOOL_NAME}"
    sudo rm -f ${TOOL_PATH}
    (
        export MAIN_PATH="$(pwd)/src/main.sh"
        envsubst < ./assets/bin-link > ${TEMP_FOLDER}/${TOOL_NAME}
        chmod +x ${TEMP_FOLDER}/${TOOL_NAME}
        sudo mv ${TEMP_FOLDER}/${TOOL_NAME} ${TOOL_PATH}
    )
    log-sep

    rm -rf ${TEMP_FOLDER}
}

main
