{ config, pkgs, system, nix-jetbrains-plugins, ... }:


# Packages that should be installed to the user profile.
let
  ideaPluginBase = nix-jetbrains-plugins.plugins.${system}.idea."2025.3.1";
  ideaPlugins = map (p: ideaPluginBase.${p}) [
    "nix-idea"
  ];
  editorPackages = with pkgs; [
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.webstorm ideaPlugins)
  ];

  # De vuilbak
  miscPackages = with pkgs; [
    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    spotify
    discord
    gitkraken

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
in
{
  home.username = "mustachio";
  home.homeDirectory = "/home/mustachio";

  # Import files from the current configuration directory into the Nix store,
  # and create symbolic links pointing to those store files in the Home directory.

  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # Import the scripts directory into the Nix store,
  # and recursively generate symbolic links in the Home directory pointing to the files in the store.
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  home.packages =
    editorPackages
    ++ miscPackages;

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Nicolas Van Damme";
    userEmail = "nicolas.van.damme2@hotmail.com";
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "WhiteSur-Dark-solid";
        icon-theme = "WhiteSur-Dark";
        cursor-theme = "WhiteSur-cursors";
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
          "spotify.desktop"
          "org.jetbrains.idea.WebStorm.desktop"
          "org.gnome.Terminal.desktop"
          "org.gnome.TextEdit.desktop"
          "org.gnome.Settings.desktop"
          "nixos-manual.desktop"
        ];
      };
      "org/gnome/shell/extensions/user-theme" = {
         name = "WhiteSur-Dark-solid";
      };
    };
  };

#  gtk = with pkgs; {
#    enable = true;
#    iconTheme = {
#      name = "WhiteSur-dark";
#      package = whitesur-icon-theme;
#    };
#    theme = {
#      name = "WhiteSur-dark";
#      package = whitesur-gtk-theme;
#    };
#    #cursorTheme = {
#    #  name = "Bibata-Modern-Ice";
#    #  package = bibata-cursors;
#    #};
#    gtk3.extraConfig = {
#      gtk-application-prefer-dark-theme = 1;
#    };
#    gtk4.extraConfig = {
#      gtk-application-prefer-dark-theme = 1;
#    };
#  };


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";
}
