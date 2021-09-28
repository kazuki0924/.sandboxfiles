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

acr/login:
> @ az acr login --name sandboxacrbasic

.PHONY: acr/login

acr/build: acr/login
> @ az acr build --registry sandboxacrbasic --image flask-demo:latest .

.PHONY: acr/build

start: acr/build
> @ docker-compose up

.PHONY: start

start/local:
> @ docker-compose -f docker-compose.local.yml up --build

.PHONY: start/local

clean:
> @ docker-compose -f docker-compose.yml -f docker-compose.local.yml down -v

.PHONY: clean

reset: clean start

.PHONY: reset

setup: start

.PHONY: setup
