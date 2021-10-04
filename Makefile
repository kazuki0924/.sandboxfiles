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

vagrant/init:
> @ vagrant init

.PHONY: vagrant/init

vagrant/up:
> @ vagrant up --provision

.PHONY: vagrant/up

vagrant/down:
> @ vagrant destroy

.PHONY: vagrant/down

vagrant/reset:
> @ vagrant destroy
> @ vagrant up

.PHONY: vagrant/reset

vagrant/ssh:
> @ vagrant ssh

.PHONY: vagrant/ssh

vagrant/up_and_ssh: vagrant/up vagrant/ssh

.PHONY: vagrant/up_and_ssh

vagrant/test@infra:
> @ py.test --hosts=vagrant-sandbox testinfra/test_infra-sandbox.py -v

.PHONY: vagrant/test@infra

azure/init:
> @ cd ./terraform/azure
> @ terraform init

.PHONY: azure/init

azure/up:
> @ source "./env/azure/.env.dev"
> @ cd ./terraform/azure
> @ terraform plan -out terraform_azure.tfplan
> @ terraform apply terraform_azure.tfplan

.PHONY: azure/up

azure/down:
> @ cd ./terraform/azure
> @ terraform destroy

.PHONY: azure/down

azure/provision:
> @ cd ./ansible/sandbox
> @ ansible-playbook -i host.azure-vm playbook_azure-vm.yml -vv

.PHONY: azure/provision

azure/ssh:
> @ ssh azure-vm-sandbox

.PHONY: azure/ssh

azure/up_and_ssh: azure/up azure/provision azure/ssh

.PHONY: azure/up_and_ssh

azure/output:
> @ cd ./terraform/azure
> @ terraform output -json > ../../json/azure/secrets_terraform_outputs.json

.PHONY: azure/outputs

azure/test@infra:
> @ py.test --hosts=azure-vm-sandbox testinfra/test_infra-sandbox.py -v

.PHONY: azure/test@infra

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

sandboxfiles/clone_to_vagrant:
> @ cd ./ansible/sandbox
> @ ansible-playbook -i host.vagrant playbook_sandboxfiles.yml -vv

.PHONY: sandboxfiles/clone_to_sandbox

sandboxfiles/clone_to_azure_vm:
> @ cd ./ansible/sandbox
> @ ansible-playbook -i host.azure-vm playbook_sandboxfiles.yml -vv

.PHONY: sandboxfiles/clone_to_azure_vm

boilerplate/flask:
> @ cp -r boilerplates/python-flask-gunicorn-nginx-docker-compose/ ~/flask-demo

.PHONY: boilerplate/flask

remove:
> @ rm -rf ~/.sandboxfiles

.PHONY: remove

setup: vagrant/reset azure/init azure/deploy azure/provision

.PHONY: setup
