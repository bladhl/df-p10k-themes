PREFIX ?= $(HOME)/.local
BIN_DIR := $(PREFIX)/bin
DATA_DIR := $(PREFIX)/share/df-p10k-themes

.PHONY: help test lint syntax install uninstall clean

help:
	@printf 'Targets:\n'
	@printf '  test      run bats specs (requires bats-core)\n'
	@printf '  lint      run shellcheck on the CLI (requires shellcheck)\n'
	@printf '  syntax    zsh -n check every theme dropin\n'
	@printf '  install   copy CLI to %s and themes to %s\n' '$(BIN_DIR)' '$(DATA_DIR)/themes'
	@printf '  uninstall remove installed CLI and themes\n'

test:
	bats tests/

lint:
	shellcheck bin/df-p10k-themes

syntax:
	@set -e; for t in themes/*.zsh; do zsh -n "$$t" && printf 'ok  %s\n' "$$t"; done

install:
	install -d '$(BIN_DIR)' '$(DATA_DIR)/themes'
	install -m 0755 bin/df-p10k-themes '$(BIN_DIR)/df-p10k-themes'
	install -m 0644 themes/*.zsh '$(DATA_DIR)/themes/'

uninstall:
	rm -f '$(BIN_DIR)/df-p10k-themes'
	rm -rf '$(DATA_DIR)'

clean:
	rm -rf tests/.bats-tmp
