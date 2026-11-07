{
  config,
  pkgs,
  nixpkgs-unstable,
  system,
  spicetify-nix,
  ...
}:

# Packages that should be installed to the user profile.
let
  spicePkgs = spicetify-nix.legacyPackages.${system};

  # De vuilbak
  miscPackages = with nixpkgs-unstable; [
    fastfetch
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
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

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

    btop # replacement of htop/nmon
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

    gitkraken

    zsh-powerlevel10k
    meslo-lgs-nf

    prusa-slicer
    signal-desktop
    obsidian
    protonmail-desktop
    synology-drive-client
    pinta

    prismlauncher

    httptoolkit
    libreoffice-fresh
  ];
in
{
  imports = [
    ./modules/gnome.nix
    ./modules/browser/librewolf.nix
    spicetify-nix.homeManagerModules.spicetify
  ];

  home.username = "mustachio";
  home.homeDirectory = "/home/mustachio";

  xdg.mimeApps.enable = true;

  home.packages = miscPackages;

  programs.spicetify = {
    enable = true;
    alwaysEnableDevTools = true;
    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      songStats
      catJamSynced
      sortPlay
      spicyLyrics
    ];
  };

  programs.vesktop = {
    enable = true;

    vencord.settings = {
      autoUpdate = true;
      autoUpdateNotification = true;
      notifyAboutUpdates = true;

      plugins = {
        ClearURLs.enabled = true;
        FixYoutubeEmbeds.enabled = true;
      };
    };
  };

  stylix.targets.spicetify.colors.override = {
    base04 = "f9cc6c"; # Make yellow great again
  };

  stylix.targets.vesktop = {
    enable = true;
    colors.override = {
      base0B = "f9cc6c"; # Make yellow great again
    };
  };

  programs.mangohud.enable = true;

  drlg = {
    shell = {
      enable = true;
      sessionPath = [ "/home/mustachio/.npm-global/bin" ];
      rebuildCommand = "nix run /home/mustachio/nixos-config#deploy-andromeda";
    };

    git = {
      enable = true;
      enableGithub = true;
    };

    jetbrains = {
      enable = true;

      editors = {
        webstorm = {
          version = "2026.2.3";
          plugins = [
            "nix-idea"
            "org.jetbrains.junie"
            "zielu.gittoolbox"
            "com.intellij.ml.llm"
            "izhangzhihao.rainbow.brackets"
            "monokai-pro"
          ];
        };

        rider = {
          version = "2026.2.3";
          plugins = [
            "org.jetbrains.junie"
            "zielu.gittoolbox"
            "com.intellij.ml.llm"
            "izhangzhihao.rainbow.brackets"
            "monokai-pro"
          ];
        };
      };
    };

    stylix = {
      enableMonokaiOverrides = true;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "yes";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      "circinus" = {
        HostName = "192.168.1.12";
        User = "root";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

      "condor" = {
        HostName = "192.168.1.20";
        User = "root";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };
    };
  };

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
