{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors

    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.show-desktop-button
    gnomeExtensions.search-light
    gnomeExtensions.gnome-40-ui-improvements
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        accent-color = "yellow";
        color-scheme = "prefer-dark";
        gtk-theme = "WhiteSur-Dark-solid";
        icon-theme = "WhiteSur-dark";
        cursor-theme = "WhiteSur-cursors";
      };
      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
        natural-scroll = false;
        speed = 0.0;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = 3600;
        sleep-inactive-ac-type = "suspend";
      };
      "org/gnome/shell/extensions/search-light" = {
        shortcut-search = [ "<Control>Return" ];
      };
      "org/gnome/shell/extensions/show-desktop-button" = {
        indicator-position = "LEFT";
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        always-center-icons = false;
        autohide = true;
        autohide-in-fullscreen = false;
        background-opacity = 0.0;
        click-action = "previews";
        custom-theme-shrink = false;
        dash-max-icon-size = 48;
        dock-position = "BOTTOM";
        extend-height = false;
        height-fraction = 0.90000000000000002;
        hide-tooltip = false;
        icon-size-fixed = false;
        isolate-monitors = true;
        multi-monitor = true;
        preferred-monitor = -2;
        preferred-monitor-by-connector = "DP-4";
        preview-size-scale = 0.0;
        show-icons-emblems = true;
        show-show-apps-button = true;
        shift-click-action = "minimize";
        shift-middle-click-action = "launch";
        middle-click-action = "launch";
        running-indicator-style = "DOTS";
        transparency-mode = "DEFAULT";
        show-mounts = false;
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          user-themes.extensionUuid
          dash-to-dock.extensionUuid
          show-desktop-button.extensionUuid
          blur-my-shell.extensionUuid
          search-light.extensionUuid
          gnome-40-ui-improvements.extensionUuid
        ];
        favorite-apps = [
          "librewolf.desktop"
          "thunderbird.desktop"
          "proton-mail.desktop"
          "steam.desktop"
          "spotify.desktop"
          "discord.desktop"
          "signal.desktop"
          "webstorm.desktop"
          "gitkraken.desktop"
          "org.gnome.Console.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Settings.desktop"
          "nixos-manual.desktop"
        ];
      };
      "org/gnome/shell/extensions/user-theme" = {
        name = "WhiteSur-Dark-solid";
      };
    };
  };
}
