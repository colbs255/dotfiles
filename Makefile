install: settings programs dotfiles

settings:
	defaults write -g ApplePressAndHoldEnabled -bool false
	defaults write com.apple.dock orientation left
programs:
	-brew bundle
	-sudo yum -y install $(cat packages.txt)
dotfiles:
	cd config && stow --target=../.. --restow *
clean:
	cd config && stow --target=../.. --delete *
lint:
	cd config && stylua wezterm/.config/wezterm/wezterm.lua nvim/.config/nvim/

.PHONY: install settings programs dotfiles lint
