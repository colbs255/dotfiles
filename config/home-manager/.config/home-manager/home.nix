{ config, pkgs, ... }:

{
  home.username = "colby";
  home.homeDirectory = "/home/colby";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    neovim
    git
    gnumake
    clang
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
    # GUI
    brave
    jetbrains.idea-community
    wezterm
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
	"lg" = "lazygit";
	"vi" = "nvim";
	"x" = "cd \"$(xplr --print-pwd-as-result)\"";
      };
    };
  };
}
