{ config, pkgs, ... }:

{
  home.username = "colby";
  home.homeDirectory = "/home/colby";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.file = {
    ".config/lazygit/".source = ./lazygit;
    ".config/ideavim/".source = ./ideavim;
    ".config/nvim/".source = ./nvim;
    ".config/rofi/".source = ./rofi;
    ".config/sway/".source = ./sway;
    ".config/swaylock/".source = ./swaylock;
    ".config/waybar/".source = ./waybar;
    ".config/wallpapers/".source = ./wallpapers;
    ".config/xplr/".source = ./xplr;
    ".config/fish/".source = ./fish;
    ".config/wezterm/".source = ./wezterm;
    ".config/foot/".source = ./foot;
    ".config/zathura/".source = ./zathura;
    ".gitconfig".source = ./git/.gitconfig;
    ".tmux.conf".source = ./tmux/.tmux.conf;
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    neovim
    git
    gnumake
    gcc
    ghc
    cabal-install
    haskell-language-server
    lazygit
    fish
    fzf
    delta
    asciidoctor
    ripgrep
    stow
    tmux
    fd
    tree
    wget
    zoxide
    xplr
    bat
    bottom
    sd
    zathura
    mupdf
    eza
    temurin-bin-21
    shellcheck
    # GUI
    flatpak
    # brave
    # jetbrains.idea-community
  ];
}
