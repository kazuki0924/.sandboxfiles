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

boilerplate/flask:
> @ cp -r boilerplates/python-flask-gunicorn-nginx-docker-compose/ ~/flask-demo

.PHONY: boilerplate/flask

remove:
> @ rm -rf ~/.sandboxfiles

.PHONY: remove

setup: vagrant/reset azure/init azure/deploy azure/provision

.PHONY: setup
