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

1. Install nix
2. Run install script
``` bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/colbs255/dotfiles/main/linux/install.sh)"
```
3. (optional) Source linux settings
```
./linux/settings.sh
```

## Update

After changing a config, run `homeupdate` for it to take effect
