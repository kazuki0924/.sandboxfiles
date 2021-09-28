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

start:
> @ docker-compose up

.PHONY: start

start/local:
> @ docker-compose -f docker-compose.local.yml up --build

.PHONY: start/local

clean: 
> @ docker-compose -f docker-compose.yml -f docker-compose.local.yml down -v

.PHONY: clean

build:
> @ az acr login --name sandboxacrbasic
> @ az acr build --registry sandboxacrbasic --image flask-demo:latest .

.PHONY: build

reset: clean start

.PHONY: reset

setup: start

.PHONY: setup
