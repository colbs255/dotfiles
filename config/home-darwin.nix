# macOS home-manager config: home-common.nix plus mac-specific config.
{ pkgs, ... }:
{
  imports = [ ./home-common.nix ];

  home.homeDirectory = "/Users/colby";

  xdg.configFile.alacritty.source = ./alacritty;

  home.packages = with pkgs; [ alacritty ];
}
