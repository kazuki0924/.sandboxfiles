#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: create service principle

az ad sp create-for-rbac --name sandbox --role Owner --sdk-auth --create-cert >>./terraform/azure/secrets_azure_sandbox.json
FILE="$(fd . -e ".pem" -d 1 --changed-within 1min -1 ~)"
declare -r FILE
mv "${FILE}" secrets_azure_sandbox.pem
