SHELL := /bin/bash

ROOT := $(CURDIR)
BIN := $(ROOT)/bin
DATA := $(ROOT)/data

.PHONY: check build run run-invalid exercise-check reset clean

check:
	@command -v cobc >/dev/null || { echo "需要安装 GnuCOBOL: cobc"; exit 1; }
	@bash -n scripts/*.sh
	@cobc -fsyntax-only -I src/copybooks src/SETTLE_WORKBOOK.COB
	@cobc -fsyntax-only src/exercises/01-hello-record.COB
	@cobc -fsyntax-only src/exercises/02-amount-check.COB
	@bash scripts/check-contracts.sh
	@echo "cobol-workbook check: OK"

build:
	mkdir -p $(BIN)
	cobc -x -I src/copybooks -o $(BIN)/settle-workbook src/SETTLE_WORKBOOK.COB

run: build
	@bash scripts/run-workbook.sh

run-invalid: build
	@set +e; INPUT_FILE=$(ROOT)/data/input/transactions-invalid.csv bash scripts/run-workbook.sh; rc=$$?; \
	if [[ $$rc -ne 12 ]]; then echo "期待 COBOL 返回 12，实际为 $$rc" >&2; exit 1; fi; \
	echo "故障练习通过: rc=$$rc"

exercise-check:
	mkdir -p $(BIN)
	cobc -x -o $(BIN)/hello-record src/exercises/01-hello-record.COB
	cobc -x -o $(BIN)/amount-check src/exercises/02-amount-check.COB
	@echo "exercise binaries: OK"

reset:
	rm -rf $(BIN) data/output work
	mkdir -p data/output work

clean: reset
