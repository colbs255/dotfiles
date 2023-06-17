#!/bin/sh

sudo dnf -y install dnf-plugins-core

# Lazygit repo
sudo dnf -y copr enable atim/lazygit

sudo dnf -y install $(cat packages.txt)
