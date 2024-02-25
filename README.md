# dotfiles

My opinionated dot files. Use at your own risk :)

## Installation

### MacOS

``` bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/colbs255/dotfiles/main/darwin/install.sh"
```

### NixOS

``` bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/colbs255/dotfiles/main/linux/nixos.sh)"
```

### Other Linux

``` bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/colbs255/dotfiles/main/linux/install.sh)"
```

## How it works

Uses the nix package manager and Home Manager to install applications and manage configurations.
Run `homeupdate` to install your latest changes via Home Manager.
