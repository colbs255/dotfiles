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
3. (silverblue only) Activate toolbox and install make
``` bash
toolbox create main && toolbox activate main && sudo dnf -y install make
```
4. Clone this repo and install
``` bash
git clone git@github.com:colbs255/dotfiles.git ~/dotfiles && cd ~/dotfiles && make
```
