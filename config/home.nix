{ pkgs, ... }:

{
  home.username = "colby";
  home.homeDirectory = "/home/colby";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [ ./firefox ];

  xdg.configFile = {
    lazygit.source = ./lazygit;
    gitui.source = ./gitui;
    ideavim.source = ./ideavim;
    nvim.source = ./nvim;
    helix.source = ./helix;
    fuzzel.source = ./fuzzel;
    hypr.source = ./hypr;
    waybar.source = ./waybar;
    wallpapers.source = ./wallpapers;
    fish.source = ./fish;
    bat.source = ./bat;
    alacritty.source = ./alacritty;
    foot.source = ./foot;
    zathura.source = ./zathura;
    git.source = ./git;
    tmux.source = ./tmux;
  };
  home.file.".bash_profile" = {
    source = ./bash/.bash_profile;
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
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
        tweaks = [
          "rimless"
          "black"
        ];
        variant = "macchiato";
      };
    };
  };

  home.packages = with pkgs; [
    neovim
    helix
    swaybg
    hyprlock
    waybar
    git
    gnumake
    just
    gcc
    gh
    ghc
    cabal-install
    haskell-language-server
    lazygit
    gitui
    fish
    foot
    alacritty
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
    yazi
    xfce.thunar
    bat
    xdg-utils
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
    mpv
    swappy
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    jetbrains.idea-community
    inkscape
  ];
}
