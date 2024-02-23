{ config, pkgs, ... }:

{
  home.username = "colby";
  home.homeDirectory = "/home/colby";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  xdg.configFile = {
    lazygit.source = ./lazygit;
    gitui.source = ./gitui;
    ideavim.source = ./ideavim;
    nvim.source = ./nvim;
    fuzzel.source = ./fuzzel;
    hypr.source = ./hypr;
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

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "macchiato";
      };
    };
  };

  home.packages = with pkgs; [
    neovim
    swaybg
    swaylock-effects
    waybar
    wlogout
    git
    gnumake
    gcc
    gh
    ghc
    cabal-install
    haskell-language-server
    lazygit
    gitui
    fish
    foot
    fuzzel
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
    xfce.thunar
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
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    jetbrains.idea-community
    brave
    inkscape
  ];
}
