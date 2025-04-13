#!/usr/bin/env bash

set -e

echo "Creating ssh key"
ssh-keygen -t ed25519

echo "Cloning and installing repo"
nix shell nixpkgs#git  nixpkgs#gh nixpkgs#bash --command bash -c '
gh auth login
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles
'

cd ~/dotfiles
nix develop --command bash -c 'just build-home && just build-system'
