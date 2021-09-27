#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: az login with service principle

# required: az

source "./env/azure/.env.dev"

az login --service-principal --username "${AZ_SP_CLIENT_ID}" --tenant "${AZ_SP_CLIENT_TENANT_ID}" --password "${AZ_SP_CLIENT_SECRET}"
