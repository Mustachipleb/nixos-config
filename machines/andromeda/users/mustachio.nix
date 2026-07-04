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

    # If it doesn't start, make sure "enableHardwareAcceleration" = false in .config/discord/settings.json
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    gitkraken

    zsh-powerlevel10k
    meslo-lgs-nf

    prusa-slicer
    signal-desktop
    obsidian
    protonmail-desktop
    synology-drive-client

    httptoolkit
  ];
in
{
  imports = [
    ./modules/gnome.nix
    ./modules/browser/librewolf.nix
    ./modules/shell/shell.nix
    ./modules/jetbrains.nix
    ./modules/git.nix
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

  stylix.targets.spicetify.colors.override = {
    base04 = "f9cc6c"; # Make yellow great again
  };

  stylix.targets.vencord = {
    enable = true;
    colors.override = {
      base0B = "f9cc6c"; # Make yellow great again
    };
  };

  programs.mangohud.enable = true;

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
