#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: scp secrets from local to azure vm

declare -r ENV_FILE="env/azure/.env.dev"
declare -r LOCAL_PATH="./${ENV_FILE}"
declare -r REMOTE_PATH="~/.sandboxfiles/${ENV_FILE}"

scp "${LOCAL_PATH}" azure-vm-sandbox:"${REMOTE_PATH}"
