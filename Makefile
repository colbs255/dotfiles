OS := $(shell uname -s)

install: settings programs dotfiles

test:
	@echo "OS: $(OS)"
settings:
	./darwin/settings.sh
programs:
	./darwin/progams.sh
dotfiles:
	cd config && stow --target=../.. --restow *
clean:
	cd config && stow --target=../.. --delete *
lint:
	cd config && stylua wezterm/.config/wezterm/wezterm.lua nvim/.config/nvim/

.PHONY: install settings programs dotfiles lint
