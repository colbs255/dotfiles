# macOS home-manager config: home-common.nix plus mac-specific config.
{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./home-common.nix ];

  home.homeDirectory = "/Users/colby";

  xdg.configFile = {
    alacritty.source = ./alacritty;
    # Only the Brewfile is managed here (not the whole homebrew/ dir) so
    # that trust.json/trust.json.lock stay writable for Homebrew's own
    # tap-trust runtime state.
    "homebrew/Brewfile".source = ./homebrew/Brewfile;
  };

  home.packages = with pkgs; [ alacritty ];

  # GUI apps (casks) don't play well when installed via Nix on macOS, so
  # they're declared in homebrew/Brewfile instead and applied here.
  home.activation.brewBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    /opt/homebrew/bin/brew bundle --file="${config.xdg.configHome}/homebrew/Brewfile"
  '';
}
