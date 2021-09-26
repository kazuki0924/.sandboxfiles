#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: scp secrets from local to azure vm

IP="$(az vm show --resource-group azure-vm-sandbox-rg --name azureVMsandbox -d --query publicIps -o tsv)"
declare -r IP

declare -r AZURE_DIR="./terraform/azure"
declare -r JSON_FILE="${AZURE_DIR}/secrets_azure_sandbox.json"
declare -r PEM_FILE="${AZURE_DIR}/secrets_azure_sandbox.pem"
declare -r REMOTE_DIR="${HOME}/.sandboxfiles/terraform/azure"

scp "${JSON_FILE}" "sandbox@${IP}:${REMOTE_DIR}"
scp "${PEM_FILE}" "sandbox@${IP}:${REMOTE_DIR}"
