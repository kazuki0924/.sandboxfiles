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
> @ cd ./terraform/azure
> @ az ad sp create-for-rbac --name sandbox --role Owner --sdk-auth --create-cert >>secrets_azure_sandbox.json
> @ FILE="$$(fd . -e ".pem" -d 1 --changed-within 1min -1 ~)"
> @ mv $$FILE secrets_azure_sandbox.pem

.PHONY: azure/create_service_principle
  
azure/login_with_service_principle:
> @ cd ./terraform/azure
> @ az login --service-principal --username $$(jq -r ".clientId" secrets_azure_sandbox.json) --tenant $$(jq -r ".tenantId" secrets_azure_sandbox.json) --password secrets_azure_sandbox.pem

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
> @ ansible-playbook -i hosts playbook_azurevm.yml -vvvv

.PHONY: azure/provision

AZURE_RG := "sandbox-rg"
AZURE_VM := "sandboxVM"

azure/ssh:
> @ ssh sandbox@"$$(az vm show --resource-group $(AZURE_RG) --name $(AZURE_VM) -d --query publicIps -o tsv)"

.PHONY: azure/ssh

vagrant/check: vagrant/up vagrant/ssh

.PHONY: vagrant/check

azure/check: azure/deploy azure/provision azure/ssh

.PHONY: azure/check

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

boilerplate/flask:
> @ cp -r boilerplates/python-flask-gunicorn-nginx-docker-compose/ ~/flask-demo

.PHONY: boilerplate/flask

pbcopy/make:
> @ echo "git clone https://github.com/kazuki0924/.sandboxfiles.git && cd .sandboxfiles"
> @ echo "git clone https://github.com/kazuki0924/.sandboxfiles.git && cd .sandboxfiles" | pbcopy

.PHONY: pbcopy/make

remove:
> @ rm -rf ~/.sandboxfiles

.PHONY: remove

setup: vagrant/reset azure/init azure/deploy azure/provision

.PHONY: setup
