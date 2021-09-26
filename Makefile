SHELL := bash
.ONESHELL:
.DELETE_ON_ERROR:
.SHELLFLAGS := -Eeuo pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

all: setup

vagrant/up:
> @ vagrant up --provision

.PHONY: vagrant/up

vagrant/reset:
> @ vagrant destroy
> @ vagrant up

.PHONY: vagrant/reset

vagrant/ssh:
> @ vagrant ssh

.PHONY: vagrant/ssh

azure/init:
> @ cd ./terraform/azure
> @ terraform init

.PHONY: azure/init

azure/create_service_principle:
> @ ./scripts/azure/create_service_principle.sh

.PHONY: azure/create_service_principle

azure/scp_secrets_from_local_to_azure_vm:
> @ ./scripts/azure/scp_secrets_from_local_to_azure_vm.sh

.PHONY: azure/scp_secrets_from_local_to_azure_vm

azure/login_with_service_principle:
> @ ./scripts/azure/az_login_with_service_principle.sh

.PHONY: azure/login_with_service_principle

azure/deploy:
> @ cd ./terraform/azure
> @ terraform plan -out terraform_azure.tfplan
> @ terraform apply terraform_azure.tfplan

.PHONY: azure/deploy

azure/destroy:
> @ cd ./terraform/azure
> @ terraform destroy

.PHONY: azure/destroy

azure/provision:
> @ cd ./ansible/sandbox
> @ ansible-playbook -i hosts playbook_azurevm.yml -vv

.PHONY: azure/provision

azure/ssh:
> @ ./scripts/azure/ssh_into_azure_vm.sh

.PHONY: azure/ssh

vagrant/up_and_ssh: vagrant/up vagrant/ssh

.PHONY: vagrant/up_and_ssh

azure/deploy_and_ssh: azure/deploy azure/provision azure/ssh

.PHONY: azure/deploy_and_ssh

azure/ssh_config:
> @ ./scripts/add_azurevm_to_ssh_config.sh

.PHONY: azure/ssh_config

gcloud/init:
> @ gcloud init

.PHONY: gcloud/init

gcloud/create_service_account:
> @ gcloud iam service-accounts create sandbox
> @ export PROJECT=$$(gcloud config list project --format=json | jq -r ".core.project")
> @ cd ./terraform/gcloud
> @ gcloud iam service-accounts keys create secrets_gcloud_sandbox.json --iam-account sandbox@$$PROJECT.iam.gserviceaccount.com
> @ echo "Add the following to your rc files:"
> @ echo "export GOOGLE_APPLICATION_CREDENTIALS="$$(pwd)/secrets_gcloud_sandbox.json""
> @ echo "export GOOGLE_APPLICATION_CREDENTIALS="$$(pwd)/secrets_gcloud_sandbox.json"" | pbcopy

.PHONY: gcloud/create_service_account

sandboxfiles/clone_to_sandbox:
> @ ansible-playbook -i hosts playbook_azurevm.yml -vv

.PHONY: sandboxfiles/clone_to_sandbox

boilerplate/flask:
> @ cp -r boilerplates/python-flask-gunicorn-nginx-docker-compose/ ~/flask-demo

.PHONY: boilerplate/flask

remove:
> @ rm -rf ~/.sandboxfiles

.PHONY: remove

setup: vagrant/reset azure/init azure/deploy azure/provision

.PHONY: setup
