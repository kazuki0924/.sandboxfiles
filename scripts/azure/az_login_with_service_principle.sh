#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: az login with service principle

declare -r AZURE_DIR="./terraform/azure"
declare -r JSON_FILE="${AZURE_DIR}/secrets_azure_sandbox.json"
declare -r PEM_FILE="${AZURE_DIR}/secrets_azure_sandbox.pem"

az login --service-principal --username "$(jq -r ".clientId" "${JSON_FILE}")" --tenant "$(jq -r ".tenantId" "${JSON_FILE}")" --password "${PEM_FILE}"
