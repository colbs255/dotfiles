# Linux-only home-manager config: Hyprland desktop stack, GTK theming, and
# packages/xdg entries that don't apply (or don't build) on macOS.
{ pkgs, ... }:
{
  imports = [ ./firefox ]; # pkgs.firefox isn't packaged for Darwin

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
      "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];
    };
  };

  xdg.configFile = {
    fuzzel.source = ./fuzzel;
    mako.source = ./mako;
    hypr.source = ./hypr;
    waybar.source = ./waybar;
    wallpapers.source = ./wallpapers;
    foot.source = ./foot;
    zathura.source = ./zathura;
    # Only uca.xml is managed here (not the whole Thunar/ dir) so that
    # thunarrc/accels.scm stay writable for Thunar's own runtime state.
    "Thunar/uca.xml".source = ./thunar/uca.xml;
  };

  # Nixpkgs 25.05 moved the location of nerdfonts and apps don't like it
  # We copy the fonts to the old location so our apps are happy
  home.file.".local/share/fonts/NerdFonts" = {
    source = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono";
    recursive = true;
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme.override {
        colorVariants = [ "dark" ];
        opacityVariants = [ "normal" ];
        altVariants = [ "normal" ];
        schemeVariants = [ "standard" ];
      };
    };
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
  };

  home.packages = with pkgs; [
    # Hyprland / Wayland desktop
    mpvpaper
    hyprlock
    hyprpicker
    waybar
    fuzzel
    mako
    libnotify
    slurp
    grim
    swappy
    wl-clipboard
    cliphist

    # File / doc viewers
    thunar
    zathura
    mupdf
    xdg-utils

    bubblewrap

    # freecad has no aarch64-darwin build in nixpkgs
    freecad
  ];
}
