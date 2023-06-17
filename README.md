# dotfiles

My opinionated dot files. Use at your own risk :)

## Install

1. (optional) Create SSH key and [add SSH key to gihthub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
``` bash
ssh-keygen -t ed25519 -C "email"
```
2. (mac only) Install homebrew
``` bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
3. (kionite only) Setup toolbox
``` bash
toolbox create main && toolbox enter main && sudo dnf -y install make
```
4. Clone this repo and install
``` bash
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles && make
```
5. (kionite only) Install flatpaks. From another terminal:
``` bash
cd ~/dotfiles && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak -y install flathub $(cat linux/flatpaks.txt)
```
