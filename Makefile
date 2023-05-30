# Get the os (Linux or Darwin) and convert it to lowercase with tr
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')

install: settings programs dotfiles

settings:
	cd $(OS) && ./settings.sh
programs:
	cd $(OS) && ./programs.sh
dotfiles:
	cd config && stow --target=../.. --restow *
lint:
	cd config && stylua wezterm/.config/wezterm/wezterm.lua nvim/.config/nvim/

.PHONY: install settings programs dotfiles lint
