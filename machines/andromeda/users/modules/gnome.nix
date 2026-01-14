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
        accent-color= "yellow";
        color-scheme = "prefer-dark";
        gtk-theme = "WhiteSur-Dark-solid";
        icon-theme = "WhiteSur-Dark";
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
        shortcut-search = [ "<Control>space" ];
      };
      "org/gnome/shell/extensions/show-desktop-button" = {
        indicator-position = "LEFT";
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
          "steam.desktop"
          "spotify.desktop"
          "webstorm.desktop"
          "org.gnome.Console.desktop"
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
