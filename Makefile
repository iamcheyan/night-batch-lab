SHELL := /bin/bash

ROOT := $(CURDIR)
BIN := $(ROOT)/bin
DATA := $(ROOT)/data
DATE := $(shell date +%Y%m%d)

.PHONY: all check build run reset fail-input clean

all: check

check:
	@bash -n scripts/linux/*.sh
	@tests/test-csv2xls-upload.sh
	@cobc -fsyntax-only -I src/cobol/copybooks src/cobol/NIGHTSETTLE.COB
	@echo "check: OK"

build:
	mkdir -p $(BIN)
	cobc -x -I src/cobol/copybooks -o $(BIN)/nightsettle src/cobol/NIGHTSETTLE.COB

run: build
	@bash scripts/linux/nightly-main.sh

fail-input:
	mv data/input/transactions.csv data/input/transactions.csv.disabled

reset:
	@if [[ -f data/input/transactions.csv.disabled ]]; then mv data/input/transactions.csv.disabled data/input/transactions.csv; fi
	rm -f data/output/* data/remote/* logs/*

clean:
	rm -rf $(BIN)
