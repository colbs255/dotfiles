#!/bin/sh

set -e

# Setup shell with our dependencies
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# Clone git repo and install
ssh-keygen -t ed25519 -C "colby@dev.com"
nix-shell -p git home-manager gh --run '
gh auth login
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles
home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake ~/dotfiles/config
'
