#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: add Azure VM to ssh config

IP="$(az vm show --resource-group azure-vm-sandbox-rg --name azureVMsandbox -d --query publicIps -o tsv)"
declare -r IP

tee -a "${HOME}/.ssh/config" <<EOF

Host azure-vm-sandbox
  HostName ${IP}
  User sandbox
  IdentityFile ${HOME}/.ssh/id_rsa
EOF
