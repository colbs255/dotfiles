# Get the os (Linux or Darwin) and convert it to lowercase with tr
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
BIN_PATH := $(shell cat $(OS)/path.txt)

install: settings programs dotfiles

test:
	@echo $(BIN_PATH)
settings:
	cd $(OS) && ./settings.sh
programs:
	cd $(OS) && ./programs.sh
dotfiles:
	cd config && $(BIN_PATH)/stow --target=../.. --restow *
lint:
	cd config && stylua wezterm/.config/wezterm/wezterm.lua nvim/.config/nvim/

.PHONY: install settings programs dotfiles lint
