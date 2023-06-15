#!/bin/sh

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.brave.Browser
flatpak install flathub org.wezfurlong.wezterm
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community

toolbox create main
toolbox enter main

sudo dnf -y install dnf-plugins-core

# Lazygit repo
sudo dnf -y copr enable atim/lazygit

sudo dnf -y install $(cat packages.txt)

sudo dnf -y remove $(cat remove.txt)
