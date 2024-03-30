{ config, pkgs, ... }:

{
  home.username = "colby";
  home.homeDirectory = "/home/colby";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  xdg.configFile = {
    lazygit.source = ./lazygit;
    gitui.source = ./gitui;
    ideavim.source = ./ideavim;
    nvim.source = ./nvim;
    fuzzel.source = ./fuzzel;
    hypr.source = ./hypr;
    wlogout.source = ./wlogout;
    waybar.source = ./waybar;
    wallpapers.source = ./wallpapers;
    fish.source = ./fish;
    alacritty.source = ./alacritty;
    foot.source = ./foot;
    zathura.source = ./zathura;
    git.source = ./git;
    tmux.source = ./tmux;
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "macchiato";
      };
    };
  };

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
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
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

  home.packages = with pkgs; [
    neovim
    swaybg
    hyprlock
    waybar
    wlogout
    git
    gnumake
    gcc
    gh
    ghc
    cabal-install
    haskell-language-server
    lazygit
    gitui
    fish
    foot
    alacritty
    fuzzel
    fzf
    delta
    asciidoctor
    ripgrep
    stow
    tmux
    fd
    tree
    wget
    zoxide
    yazi
    xfce.thunar
    bat
    xdg-utils
    bottom
    sd
    zathura
    mupdf
    eza
    temurin-bin-21
    shellcheck
    nodePackages.bash-language-server
    slurp
    grim
    swappy
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    jetbrains.idea-community
    brave
    inkscape
  ];
}
