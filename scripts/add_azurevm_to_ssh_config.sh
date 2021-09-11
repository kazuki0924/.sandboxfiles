#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: add Azure VM to ssh config

IP="$(az vm show --resource-group sandbox-rg --name sandboxVM -d --query publicIps -o tsv)"
declare -r IP

tee -a "${HOME}/.ssh/config" <<EOF

Host sandboxVM
  HostName ${IP}
  User sandbox
  IdentityFile ${HOME}/.ssh/id_rsa
EOF
