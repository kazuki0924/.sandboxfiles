#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# sandbox: generate secrets env file from secrets json file

# required: jq

declare -r ENV_FILE="./env/aws/.env.dev"

generate_env() {
  TARGET="${1:=""}"
  declare -r JSON_FILE="./json/aws/${TARGET}/secrets_terraform_outputs.json"
  mapfile -t KEYS < <(<"${JSON_FILE}" jq -r 'keys | @sh' | tr -d \')

  for KEY in "${KEYS[@]}"; do
    VALUE="$(<"${JSON_FILE}" jq -r ".${KEY}.value")"
    echo "export ${KEY^^}=\"${VALUE}\"" >> "${ENV_FILE}"
  done
}

generate_env aws-cognito
