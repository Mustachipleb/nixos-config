{
  config,
  pkgs,
  system,
  nix-jetbrains-plugins,
  ...
}:

# Packages that should be installed to the user profile.
let
  ideaPluginBase = nix-jetbrains-plugins.plugins.${system}.idea."2025.3.1";
  webstormPlugins = map (p: ideaPluginBase.${p}) [
    "nix-idea"
    "org.jetbrains.junie"
    "zielu.gittoolbox"
    "com.intellij.ml.llm"
    "izhangzhihao.rainbow.brackets"
    "monokai-pro"
  ];
  riderPlugins = map (p: ideaPluginBase.${p}) [
    "org.jetbrains.junie"
    "zielu.gittoolbox"
    "com.intellij.ml.llm"
    "izhangzhihao.rainbow.brackets"
    "monokai-pro"
  ];
  editorPackages = with pkgs; [
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.webstorm webstormPlugins)
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.rider riderPlugins)
  ];

  # De vuilbak
  miscPackages = with pkgs; [
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

    spotify
    discord
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
  ];

  home.username = "mustachio";
  home.homeDirectory = "/home/mustachio";

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

  home.packages = editorPackages ++ miscPackages;

  # basic configuration of git
  programs.git = {
    enable = true;
    settings = {
      user.name = "Nicolas Van Damme";
      user.email = "mustachio@dragonlegion.be";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  home = {
    sessionPath = [
      "/home/mustachio/.npm-global/bin"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./dotfiles;
        file = "p10k.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
    shellAliases = {
      rebuild = "nix run /home/mustachio/nixos-config/machines/andromeda#deploy-andromeda";
    };
    history.size = 10000;
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
