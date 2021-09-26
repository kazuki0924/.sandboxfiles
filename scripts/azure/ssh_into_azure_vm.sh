#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: ssh into azure vm

ssh sandbox@"$(az vm show --resource-group azure-vm-sandbox-rg --name azureVMsandbox -d --query publicIps -o tsv)"
