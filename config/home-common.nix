# Cross-platform home-manager config: shared across NixOS and macOS.
# Imported by ./home-linux.nix / ./home-darwin.nix, which add OS-specific
# config (desktop environment, GTK, xdg mime, etc.) on top.
{ pkgs, ... }:
{
  home.username = "colby";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  xdg.configFile = {
    lazygit.source = ./lazygit;
    gitui.source = ./gitui;
    ideavim.source = ./ideavim;
    nvim.source = ./nvim;
    helix.source = ./helix;
    fish.source = ./fish;
    bat.source = ./bat;
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
  };

  home.file.".bash_profile".source = ./bash/.bash_profile;
  # Only these paths are managed, not the whole ~/.claude dir.
  home.file.".claude/settings.json".source = ./claude/settings.json;
  home.file.".claude/commands".source = ./claude/commands;
  home.file.".claude/skills".source = ./claude/skills;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Editors / IDEs
    neovim
    helix

    # Shell / terminal / CLI
    fish
    tmux
    zoxide
    fzf
    yazi
    bat
    eza
    tree
    fd
    ripgrep
    sd
    bottom
    jq
    ouch
    wget

    # Git / VCS
    git
    gh
    lazygit
    gitui
    delta

    # AI / agent tooling
    opencode
    claude-code
    herdr
    hunk

    # Dev toolchains
    gnumake
    just
    gcc
    tree-sitter
    temurin-bin-25
    shellcheck
    bash-language-server
    direnv

    # Misc
    nerd-fonts.jetbrains-mono
    bitwarden-cli
  ];
}
