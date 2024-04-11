#!/usr/bin/env bash

set -e

# Setup shell with our dependencies
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

# Create ssk-key
ssh-keygen -t ed25519 -C "colby@dev.com"

# Clone and install
nix shell nixpkgs#git nixpkgs#home-manager nixpkgs#gh nixpkgs#bash --command bash -c '
gh auth login
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles
home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake ~/dotfiles/config
'
