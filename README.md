# dotfiles

My opinionated dot files. Use at your own risk :)

## Install

(optional) Create SSH key and [add SSH key to gihthub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
``` bash
ssh-keygen -t ed25519 -C "email"
```
### MacOS

1. Install homebrew
``` bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
2. Clone this repo and install
``` bash
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles && make
```
### Fedora Kinoite/Silverblue

1. Setup toolbox
``` bash
toolbox create main
toolbox enter main
```
2. Clone this repo and install
``` bash
sudo dnf -y install make
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles && make
```
3. Install flatpaks (run from host terminal)
``` bash
cd ~/dotfiles && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak -y install flathub $(cat linux/flatpaks.txt)
```
4. Remove firefox
``` bash
rpm-ostree override remove firefox firefox-langpacks
```
