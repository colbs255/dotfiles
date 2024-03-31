{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      DontCheckDefaultBrowser = true;
      NewTabPage = false;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"
    };

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      search = {
        force = true;
        default = "Google";
        engines = {
          "Nix Packages" = {
            definedAliases = [ ",np" ];
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
          };
          "YouTube" = {
            definedAliases = [ ",yt" ];
            urls = [{
              template = "https://www.youtube.com/results";
              params = [
                { name = "search_query"; value = "{searchTerms}"; }
              ];
            }];
          };
        };
      };

      bookmarks = [
        { name = "Charles Schwab"; url = "https://www.schwab.com/"; }
      ];

      settings = {
        "browser.startup.homepage" = "about:blank";
        "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
        "extensions.pocket.enabled" = { Value = "false"; Status = "locked"; };
      };

      extensions = with pkgs.firefox-extensions; [
        ublock-origin
        bitwarden
      ];
    };
  };
}
