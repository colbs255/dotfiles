{ config, pkgs, ... }:

{
  home.username = "colby";
  home.homeDirectory = "/home/colby";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  xdg.configFile = {
    lazygit.source = ./lazygit;
    ideavim.source = ./ideavim;
    nvim.source = ./nvim;
    rofi.source = ./rofi;
    sway.source = ./sway;
    swaylock.source = ./swaylock;
    waybar.source = ./waybar;
    wallpapers.source = ./wallpapers;
    xplr.source = ./xplr;
    fish.source = ./fish;
    wezterm.source = ./wezterm;
    foot.source = ./foot;
    zathura.source = ./zathura;
    git.source = ./git;
    tmux.source = ./tmux;
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    neovim
    git
    gnumake
    gcc
    gh
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
    nodePackages.bash-language-server
    slurp
    grim
    jetbrains-mono
    # GUI
    jetbrains.idea-community
    brave
    # flatpak
    # wezterm
  ];
}
