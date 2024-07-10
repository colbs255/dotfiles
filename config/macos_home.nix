{ pkgs, ... }:

{
  home.username = "colby";
  home.homeDirectory = "/Users/colby";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  xdg.configFile = {
    lazygit.source = ./lazygit;
    ideavim.source = ./ideavim;
    nvim.source = ./nvim;
    helix.source = ./helix;
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
  # Nixpkgs 25.05 moved the location of nerdfonts and apps don't like it
  # We copy the fonts to the old location so our apps are happy
  home.file.".local/share/fonts/NerdFonts" = {
    source = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono";
    recursive = true;
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
    helix
    git
    gnumake
    just
    gcc
    gh
    ghc
    cabal-install
    haskell-language-server
    lazygit
    direnv
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
    eza
    temurin-bin-21
    shellcheck
    nodePackages.bash-language-server
    mpv
    nerd-fonts.jetbrains-mono
    jetbrains.idea-community
    inkscape
    ouch
  ];
}
