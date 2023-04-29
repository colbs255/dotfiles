configs := fish nvim wezterm tmux ideavim git lazygit

install: mac_settings programs dotfiles

mac_settings:
	defaults write -g ApplePressAndHoldEnabled -bool false
	defaults write com.apple.dock orientation left
programs:
	brew bundle
dotfiles:
	$(foreach config,$(configs), \
		/opt/homebrew/bin/stow $(config); \
	)
lint:
	stylua wezterm/.config/wezterm/wezterm.lua nvim/.config/nvim/

.PHONY: install mac_settings programs dotfiles lint
