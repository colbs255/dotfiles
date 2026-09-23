# macOS home-manager config: home-common.nix plus mac-specific config.
{ pkgs, lib, ... }:
{
  imports = [ ./home-common.nix ];

  home.homeDirectory = "/Users/colby";

  xdg.configFile.alacritty.source = ./alacritty;

  home.packages = with pkgs; [ alacritty ];

  # GUI apps don't play well when installed with Nix, so we use Homebrew instead.
  home.activation.brewBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    /opt/homebrew/bin/brew bundle --file="${./homebrew/Brewfile}"
  '';
}
