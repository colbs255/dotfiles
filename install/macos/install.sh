#!/usr/bin/env bash

set -e

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.dock orientation left

echo "Installing homemanager channel"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

echo "Creating ssh key"
ssh-keygen -t ed25519 -C "colby@dev.com"

echo "Cloning and installing repo"
nix shell nixpkgs#git nixpkgs#home-manager nixpkgs#gh nixpkgs#bash nixpkgs#just --command bash -c '
gh auth login
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles
just build-home
'
