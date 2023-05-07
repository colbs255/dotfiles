#!/bin/sh

sudo dnf -y install dnf-plugins-core

# Brave repo
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

# Lazygit repo
sudo dnf -y copr enable atim/lazygit

sudo dnf -y install $(cat linux/packages.txt)

sudo dnf -y remove $(cat linux/remove.txt)

echo "Note: you may have to run 'sudo alternatives --config java' to choose your java"
