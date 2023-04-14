configs := fish nvim wezterm tmux ideavim git

install: mac_settings programs dotfiles

mac_settings:
	defaults write -g ApplePressAndHoldEnabled -bool false
	defaults write com.apple.dock orientation left
programs:
	brew bundle
dotfiles:
	$(foreach config,$(configs), \
		stow $(config); \
	)

.PHONY: install mac_settings programs dotfiles
