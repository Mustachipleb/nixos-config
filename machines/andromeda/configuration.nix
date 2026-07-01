# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/graphics.nix
    ./modules/gnome.nix
    ./modules/browser/librewolf.nix
    ./modules/mounts.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.fstrim.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "andromeda"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
  #  services.openvpn.servers = {
  #    airVPN = {
  #      config = ''config /root/nixos/openvpn/airvpn.ovpn '';
  #      updateResolvConf = true;
  #    };
  #  };

  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  users.users.mustachio = {
    isNormalUser = true;
    description = "Mustachio";
    extraGroups = [
      "networkmanager"
      "wheel"
      "keys"
      "fuse"
      "docker"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOw3bIQ+Ss8sjcYU5QyADiVs+ymCcRw0/4mi/Yk3LGxI mustachio@andromeda.dragonlegion.be"
    ];
  };

  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = ./users/dotfiles/base16-monokai.yaml;
    fonts = {
      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/home/mustachio/nixos-config/machines/andromeda"; # sets NH_OS_FLAKE variable for you
  };

  # Enables running generic binaries through NixOS.
  # This goes against the core principles of NixOS, but in some cases it is much simpler than dealing with alternative means.
  # I mostly intend to use this for running pre-packaged binaries in node modules.
  programs.nix-ld = {
    enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with nixpkgs-unstable; [
    librewolf

    hydrapaper # Spanned wallpaper config
    sshfs # Needed for network mounts with fuse
    nixfmt # Nix file formatter
    nil # Language server to use in IDE

    # Thermals and monitoring
    lm_sensors
    lshw
    nvtopPackages.nvidia
    liquidctl

    nodejs_24
  ];

  # Use native wayland for chromium apps (Electron etc)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Thermals
  services.thermald.enable = true;
  programs.coolercontrol.enable = true;

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
