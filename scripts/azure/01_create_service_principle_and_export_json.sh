#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: create azure service principle and export the values to json

# required: az

declare -r JSON_FILE="./json/azure/secrets_owner_sp.json"

az ad sp create-for-rbac --name sandbox-sp --role owner --sdk-auth >>"${JSON_FILE}"
