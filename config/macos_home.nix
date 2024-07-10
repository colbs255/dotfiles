{ pkgs, ... }:

{
  home.username = "colby";
  home.homeDirectory = "/Users/colby";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  xdg.configFile = {
    lazygit.source = ./lazygit;
    ideavim.source = ./ideavim;
    nvim.source = ./nvim;
    wallpapers.source = ./wallpapers;
    fish.source = ./fish;
    bat.source = ./bat;
    alacritty.source = ./alacritty;
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

  home.packages = with pkgs; [
    neovim
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
    alacritty
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
    mpv
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    jetbrains.idea-community
    inkscape
  ];
}
