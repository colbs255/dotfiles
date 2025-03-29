{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
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
      PasswordManagerEnabled = false;
    };

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      userChrome = builtins.readFile ./userChrome.css;
      search = {
        force = true;
        default = "google";
        engines = {
          "Nix Packages" = {
            definedAliases = [ ",np" ];
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
          "youTube" = {
            definedAliases = [ ",yt" ];
            urls = [
              {
                template = "https://www.youtube.com/results";
                params = [
                  {
                    name = "search_query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
        };
      };

      bookmarks = {
        force = true;
        settings = [
          {
            name = "Charles Schwab";
            url = "https://www.schwab.com/";
          }
          {
            name = "Router Settings";
            url = "https://192.168.1.1/";
          }
          {
            name = "Dotfiles";
            url = "https://github.com/colbs255/dotfiles/";
          }
          {
            name = "Github";
            url = "https://github.com/";
          }
        ];
      };

      settings = {
        "browser.startup.homepage" = "about:blank";
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "extensions.pocket.enabled" = {
          Value = "false";
          Status = "locked";
        };
        "toolkit.legacyUserProfileCustomizations.stylesheets" = "true";
      };

      extensions.packages = with pkgs.firefox-extensions; [
        ublock-origin
        bitwarden
        react-devtools
      ];
    };
  };
}
