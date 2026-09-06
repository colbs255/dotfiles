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
    mako.source = ./mako;
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
    # Only the config file is managed here (not the whole herdr/ dir) so that
    # the rest of the directory stays writable for herdr's runtime socket/state.
    "herdr/config.toml".source = ./herdr/config.toml;
    # Only the config file is managed here (not the whole gh/ dir) so that
    # hosts.yml stays a regular writable file for `gh auth login` to use.
    "gh/config.yml".source = ./gh/config.yml;
  };
  home.file.".bash_profile" = {
    source = ./bash/.bash_profile;
  };
  # Only these two files are managed, not the whole ~/.claude dir.
  home.file.".claude/settings.json".source = ./claude/settings.json;
  home.file.".claude/statusline-command.sh".source = ./claude/statusline-command.sh;
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

  gtk = {
    enable = true;
    gtk4.theme = null;
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
    lazygit
    localsend
    direnv
    gitui
    fish
    foot
    alacritty
    fuzzel
    mako
    libnotify
    fzf
    delta
    jq
    ripgrep
    stow
    tmux
    fd
    tree
    wget
    zoxide
    yazi
    thunar
    bat
    xdg-utils
    bottom
    sd
    zathura
    mupdf
    eza
    temurin-bin-25
    shellcheck
    bash-language-server
    slurp
    grim
    mpv
    opencode
    claude-code
    swappy
    hyprpicker
    wl-clipboard
    cliphist
    nerd-fonts.jetbrains-mono
    jetbrains.idea
    godot
    inkscape
    openscad-unstable
    freecad
    ouch
    herdr
  ];
}
