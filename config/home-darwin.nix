# macOS home-manager config: home-common.nix plus mac-specific config.
{ pkgs, lib, ... }:
{
  imports = [ ./home-common.nix ];

  home.homeDirectory = "/Users/colby";

  xdg.configFile.alacritty.source = ./alacritty;

  home.packages = with pkgs; [ alacritty ];

  # GUI apps (casks) don't play well when installed via Nix on macOS, so
  # they're declared in homebrew/Brewfile instead and applied here. Referenced
  # by its Nix store path so we never have to touch ~/.config/homebrew, which
  # Homebrew itself owns (trust.json, trust.json.lock, etc).
  home.activation.brewBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    /opt/homebrew/bin/brew bundle --file="${./homebrew/Brewfile}"
  '';
}
