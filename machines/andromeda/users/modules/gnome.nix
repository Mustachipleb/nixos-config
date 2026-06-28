{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}:

{
  home.packages = with nixpkgs-unstable; [
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors

    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.show-desktop-button
    gnomeExtensions.search-light
    gnomeExtensions.gnome-40-ui-improvements
    gnomeExtensions.appindicator
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
      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "spanned";
        picture-uri = "file:///home/mustachio/.cache/org.gabmus.hydrapaper/merged_wallpaper.png";
        picture-uri-dark = "file:///home/mustachio/.cache/org.gabmus.hydrapaper/merged_wallpaper_dark.png";
        primary-color = "#241f31";
        secondary-color = "#000000";
      };
      "org/gnome/mutter" = {
        workspaces-only-on-primary = true;
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
        isolate-monitors = false;
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
        enabled-extensions = with nixpkgs-unstable.gnomeExtensions; [
          user-themes.extensionUuid
          dash-to-dock.extensionUuid
          show-desktop-button.extensionUuid
          blur-my-shell.extensionUuid
          search-light.extensionUuid
          gnome-40-ui-improvements.extensionUuid
          appindicator.extensionUuid
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
        remember-mount-password = true;
      };
      "org/gnome/shell/extensions/user-theme" = {
        name = "WhiteSur-Dark-solid";
      };
    };
  };

  # Display config
  home.file.".config/monitors.xml".text = ''
    <monitors version="2">
      <configuration>
        <layoutmode>physical</layoutmode>
        <logicalmonitor>
          <x>5120</x>
          <y>0</y>
          <scale>1</scale>
          <monitor>
            <monitorspec>
              <connector>DP-1</connector>
              <vendor>MSI</vendor>
              <product>MSI G273Q</product>
              <serial>CA8A402801172</serial>
            </monitorspec>
            <mode>
              <width>2560</width>
              <height>1440</height>
              <rate>59.940</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <logicalmonitor>
          <x>2560</x>
          <y>0</y>
          <scale>1</scale>
          <primary>yes</primary>
          <monitor>
            <monitorspec>
              <connector>DP-3</connector>
              <vendor>MSI</vendor>
              <product>MSI G273Q</product>
              <serial>CA8A402801071</serial>
            </monitorspec>
            <mode>
              <width>2560</width>
              <height>1440</height>
              <rate>59.940</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <logicalmonitor>
          <x>0</x>
          <y>0</y>
          <scale>1</scale>
          <monitor>
            <monitorspec>
              <connector>DP-2</connector>
              <vendor>MSI</vendor>
              <product>MSI G273Q</product>
              <serial>CA8A402801145</serial>
            </monitorspec>
            <mode>
              <width>2560</width>
              <height>1440</height>
              <rate>59.940</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <disabled>
          <monitorspec>
            <connector>HDMI-1</connector>
            <vendor>BSE</vendor>
            <product>Cinemate</product>
            <serial>0x00000000</serial>
          </monitorspec>
        </disabled>
      </configuration>
      <configuration>
        <layoutmode>physical</layoutmode>
        <logicalmonitor>
          <x>2560</x>
          <y>0</y>
          <scale>1</scale>
          <primary>yes</primary>
          <monitor>
            <monitorspec>
              <connector>DP-4</connector>
              <vendor>MSI</vendor>
              <product>MSI G273Q</product>
              <serial>CA8A402801071</serial>
            </monitorspec>
            <mode>
              <width>2560</width>
              <height>1440</height>
              <rate>164.835</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <logicalmonitor>
          <x>5120</x>
          <y>0</y>
          <scale>1</scale>
          <monitor>
            <monitorspec>
              <connector>DP-2</connector>
              <vendor>MSI</vendor>
              <product>MSI G273Q</product>
              <serial>CA8A402801172</serial>
            </monitorspec>
            <mode>
              <width>2560</width>
              <height>1440</height>
              <rate>164.835</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <logicalmonitor>
          <x>0</x>
          <y>0</y>
          <scale>1</scale>
          <monitor>
            <monitorspec>
              <connector>DP-3</connector>
              <vendor>MSI</vendor>
              <product>MSI G273Q</product>
              <serial>CA8A402801145</serial>
            </monitorspec>
            <mode>
              <width>2560</width>
              <height>1440</height>
              <rate>164.835</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <disabled>
          <monitorspec>
            <connector>HDMI-2</connector>
            <vendor>BSE</vendor>
            <product>Cinemate</product>
            <serial>0x00000000</serial>
          </monitorspec>
        </disabled>
      </configuration>
      <configuration>
        <layoutmode>logical</layoutmode>
        <logicalmonitor>
          <x>5120</x>
          <y>0</y>
          <scale>1</scale>
          <monitor>
            <monitorspec>
              <connector>DP-2</connector>
              <vendor>MSI</vendor>
              <product>MSI G273Q</product>
              <serial>CA8A402801172</serial>
            </monitorspec>
            <mode>
              <width>2560</width>
              <height>1440</height>
              <rate>164.835</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <logicalmonitor>
          <x>2560</x>
          <y>0</y>
          <scale>1</scale>
          <primary>yes</primary>
          <monitor>
            <monitorspec>
              <connector>DP-4</connector>
              <vendor>MSI</vendor>
              <product>MSI G273Q</product>
              <serial>CA8A402801071</serial>
            </monitorspec>
            <mode>
              <width>2560</width>
              <height>1440</height>
              <rate>164.835</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <logicalmonitor>
          <x>0</x>
          <y>0</y>
          <scale>1</scale>
          <monitor>
            <monitorspec>
              <connector>DP-3</connector>
              <vendor>MSI</vendor>
              <product>MSI G273Q</product>
              <serial>CA8A402801145</serial>
            </monitorspec>
            <mode>
              <width>2560</width>
              <height>1440</height>
              <rate>164.835</rate>
            </mode>
          </monitor>
        </logicalmonitor>
        <disabled>
          <monitorspec>
            <connector>HDMI-2</connector>
            <vendor>BSE</vendor>
            <product>Cinemate</product>
            <serial>0x00000000</serial>
          </monitorspec>
        </disabled>
      </configuration>
    </monitors>
  '';
}
