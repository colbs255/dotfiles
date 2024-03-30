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

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
        };
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
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            definedAliases = [ ":np" ];
          };
          "YouTube" = {
            urls = [{
              template = "https://www.youtube.com/results";
              params = [
              { name = "search_query"; value = "{searchTerms}"; }
              ];
            }];
            definedAliases = [ ":yt" ];
          };
        };
      };

      bookmarks = [
      { name = "Charles Schwab"; url = "https://www.schwab.com/"; }
      ];

      settings = {
        "browser.startup.homepage" = "about:blank";
        "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
      };
    };
  };
}
