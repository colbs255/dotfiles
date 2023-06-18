#!/bin/sh

# Clone
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak -y install flathub $(cat linux/flatpaks.txt)

# Remove pre-installed apps
rpm-ostree override remove firefox firefox-langpacks

# Create main toolbox
toolbox create main
toolbox run -c main sudo dnf -y install make
toolbox run -c main make
