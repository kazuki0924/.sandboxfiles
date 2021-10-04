#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: install dependencies for the project

# required: brew python

brew install azure-cli tfenv ansible jq
brew install --cask vagrant

tfenv install latest

pip install pytest-testinfra paramiko
