configs := fish nvim wezterm tmux ideavim

install: mac_settings homebrew programs dotfiles

mac_settings:
	defaults write -g ApplePressAndHoldEnabled -bool false
	defaults write com.apple.dock orientation left
homebrew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
programs:
	brew bundle
dotfiles:
	$(foreach config,$(configs), \
		stow $(config); \
	)

.PHONY: install mac_settings homebrew programs dotfiles
