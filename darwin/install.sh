#!/bin/sh

# Setup shell with our dependencies
nix-shell -p git home-manager
# Clone repo
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles
# Setup home-manager
home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake ~/dotfiles/config
brew bundle
