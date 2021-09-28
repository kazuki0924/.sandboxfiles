#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: generate secrets env file from secrets json file

# required: az jq

declare -r JSON_FILE="./json/azure/secrets_owner_sp.json"
declare -r ENV_FILE="./env/azure/.env.dev"

function get_value() {
	jq -r ".${1:-}" "${JSON_FILE}"
}

AZ_SUBSCRIPTION_ID="$(get_value subscriptionId)"
AZ_SP_CLIENT_ID="$(get_value clientId)"
AZ_SP_CLIENT_SECRET="$(get_value clientSecret)"
AZ_SP_CLIENT_TENANT_ID="$(get_value tenantId)"
declare -r AZ_SUBSCRIPTION_ID AZ_SP_CLIENT_ID AZ_SP_CLIENT_SECRET AZ_SP_CLIENT_TENANT_ID

cat >"${ENV_FILE}" <<EOF
export AZ_SUBSCRIPTION_ID="${AZ_SUBSCRIPTION_ID}"
export AZ_SP_CLIENT_ID="${AZ_SP_CLIENT_ID}"
export AZ_SP_CLIENT_SECRET="${AZ_SP_CLIENT_SECRET}"
export AZ_SP_CLIENT_TENANT_ID="${AZ_SP_CLIENT_TENANT_ID}"
export TF_VAR_subscription_id="${AZ_SUBSCRIPTION_ID}"
export TF_VAR_sp_client_id="${AZ_SP_CLIENT_ID}"
export TF_VAR_sp_client_secret="${AZ_SP_CLIENT_SECRET}"
export TF_VAR_sp_client_tenant_id="${AZ_SP_CLIENT_TENANT_ID}"
EOF
