#!/usr/bin/env bash

set -e

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.dock orientation left

echo "Installing homemanager channel"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

echo "Creating ssh key"
ssh-keygen -t ed25519

echo "Cloning and installing repo"
nix shell nixpkgs#git nixpkgs#gh nixpkgs#bash --command bash -c '
gh auth login
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles
'

cd ~/dotfiles
nix develop --command bash -c 'just build-home'
