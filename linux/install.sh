#!/bin/sh

set -e

# Install nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
if [ -e /home/colby/.nix-profile/etc/profile.d/nix.sh ]; then . /home/colby/.nix-profile/etc/profile.d/nix.sh; fi

# Setup shell with our dependencies
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell -p git home-manager gh
ssh-keygen -t ed25519 -C "colby@dev.com"
gh auth login

# Clone repo
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles
# Setup home-manager
home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake ~/dotfiles/config
# Flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak -y install flathub "$(cat linux/flatpaks.txt)"

# Settings
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
