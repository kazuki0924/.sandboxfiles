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
> @ docker-compose up --build

.PHONY: start

clean: 
> @ docker-compose down -v

.PHONY: clean

reset: clean start

.PHONY: reset

setup: start

.PHONY: setup
