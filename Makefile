install: settings programs dotfiles

settings:
	defaults write -g ApplePressAndHoldEnabled -bool false
	defaults write com.apple.dock orientation left
programs:
	-brew bundle
	./linux/install.sh
dotfiles:
	cd config && stow --target=../.. --restow *
clean:
	cd config && stow --target=../.. --delete *
linuxprograms:
	./linux/install.sh
lint:
	cd config && stylua wezterm/.config/wezterm/wezterm.lua nvim/.config/nvim/

.PHONY: install settings programs dotfiles lint
