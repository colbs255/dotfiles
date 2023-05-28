install: mac_settings programs dotfiles

mac_settings:
	defaults write -g ApplePressAndHoldEnabled -bool false
	defaults write com.apple.dock orientation left
programs:
	brew bundle
dotfiles:
	cd config && stow --target=../.. --restow *
clean:
	cd config && stow --target=../.. --delete *
lint:
	cd config && stylua wezterm/.config/wezterm/wezterm.lua nvim/.config/nvim/

.PHONY: install mac_settings programs dotfiles lint
