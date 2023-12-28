#!/bin/sh

# Setup shell with our dependencies
nix-shell -p git home-manager
# Clone repo
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles
# Setup home-manager
home-manager -f ~/dotfiles/config/home.nix switch
# Flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak -y install flathub $(cat linux/flatpaks.txt)
