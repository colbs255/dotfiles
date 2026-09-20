# macOS home-manager config: home-common.nix plus mac-specific config.
# Empty for now — fill in as mac-specific needs (packages that only make
# sense there, mac app config, etc.) come up.
{ pkgs, ... }:
{
  imports = [ ./home-common.nix ];

  home.packages = with pkgs; [ ];
}
