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

### Nix Package Manager (BETA)

``` bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/colbs255/dotfiles/main/linux/install.sh)"
```

## Update

Run `homeupdate` to install your latest changes
