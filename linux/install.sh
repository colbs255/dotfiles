#!/bin/sh

set -e

# Setup shell with our dependencies
nix-shell -p git home-manager
# Clone repo
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles
# Setup home-manager
home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake ~/dotfiles/config
# Flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak -y install flathub "$(cat linux/flatpaks.txt)"

# Settings
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
