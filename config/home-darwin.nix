# macOS-only home-manager config. Empty for now — fill in as mac-specific
# needs (packages that only make sense there, mac app config, etc.) come up.
{ pkgs, ... }:
{
  home.packages = with pkgs; [ ];
}
