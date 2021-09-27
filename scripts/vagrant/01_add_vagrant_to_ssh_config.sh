#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: add vagrant to ssh config

# required: vagrant

tee -a "${HOME}/.ssh/config" <<EOF

$(vagrant ssh-config --host vagrant-sandbox)
EOF
