configs := fish nvim wezterm tmux

all: programs configs macos_defaults
programs:
	brew bundle
configs:
	$(foreach config,$(configs), \
		stow $(config); \
	)
macos_defaults:
	defaults write -g ApplePressAndHoldEnabled -bool false
	
.PHONY: programs configs macos_defaults all
