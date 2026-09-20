{ pkgs, ... }:

{
  home.username = "colby";
  home.homeDirectory = "/home/colby";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [ ./firefox ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
      "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];
    };
  };

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
    # Only the config file is managed here (not the whole hunk/ dir) so that
    # state.json and extensions/ stay writable for hunk's own runtime use.
    "hunk/config.toml".source = ./hunk/config.toml;
    # Only these files are managed here (not the whole herdr/ dir) so that
    # the rest of the directory stays writable for herdr's runtime socket/state.
    "herdr/config.toml".source = ./herdr/config.toml;
    "herdr/scripts/spawn-agent.sh" = {
      source = ./herdr/scripts/spawn-agent.sh;
      executable = true;
    };
    "herdr/scripts/spawn-agent-runner.sh" = {
      source = ./herdr/scripts/spawn-agent-runner.sh;
      executable = true;
    };
    # Only the config file is managed here (not the whole gh/ dir) so that
    # hosts.yml stays a regular writable file for `gh auth login` to use.
    "gh/config.yml".source = ./gh/config.yml;
    # Only uca.xml is managed here (not the whole Thunar/ dir) so that
    # thunarrc/accels.scm stay writable for Thunar's own runtime state.
    "Thunar/uca.xml".source = ./thunar/uca.xml;
  };
  home.file.".bash_profile" = {
    source = ./bash/.bash_profile;
  };
  home.file.".local/bin/claude-sandboxed" = {
    source = ./claude-sandbox/claude-sandboxed.sh;
    executable = true;
  };
  # Only these paths are managed, not the whole ~/.claude dir.
  home.file.".claude/settings.json".source = ./claude/settings.json;
  home.file.".claude/commands".source = ./claude/commands;
  home.file.".claude/skills".source = ./claude/skills;
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
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme.override {
        colorVariants = [ "dark" ];
        opacityVariants = [ "normal" ];
        altVariants = [ "normal" ];
        schemeVariants = [ "standard" ];
      };
    };
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
  };

  home.packages = with pkgs; [
    neovim
    helix
    mpvpaper
    hyprlock
    waybar
    git
    gnumake
    just
    gcc
    tree-sitter
    gh
    lazygit
    hunk
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
    bubblewrap
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
    bitwarden-cli
    bubblewrap
  ];
}
