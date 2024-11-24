# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.extraModulePackages = [ config.boot.kernelPackages.rtl8821ce ];
  #boot.blacklistedKernelModules = [
  #  "rtw_8821ce"
  #];

  networking.hostName = "nixos-box1"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8443 ];
  };

  programs.zsh.enable = true;

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mustachio = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDyLrBCA5c7OEX1Shziwq/jSoZTMeES1oaHt6Pibf/vLZaQf0EJQfFc41UUyHeYpLrgpQmy0r+Zwzq65zAz6Zo+wk6Hs1xZvaYf35jKsS/IXfkIU2TriRxYxXA4Mrh/tS3aWGMd7dO5/U6apGen2eVpb2S9mKxOpdrnU6vIMrRFqcNhcYTWEoy+fxXfNeUliiOXqT63ImOTLEudSWCGbmvO4ljEHGr9s1DqF6An0HvAhNRwlI1mR30oTcblfBX4qTDeB7svkBp+tpEREbSlU/2Vx6RO+fNMvBaqDQx0a4+ic5Udo6zbZCx/2+RM0eRFuk5R8sNuE6tULbF1FC5yNPNODKoRbqbYqqZLOYtrY6YV0C63Ixu8bY64/+4l9LBDacstQcn5Puj6ibqN2AM19TA+8imqfWVe1cX9sz/GZY/UBsxrR2X94l5jTNWkvN9KERVW+kYwyC4XMdZapA9EhD+u+I6Wd6mUeD4Z6m9D1LWGUT2mfQ7NQMFEWpwWw1ZHxx2ul7ACcbBZ21m56wNZxChgKaVh0yomGL7BKsEEehSRRm58hBvx9z7fSp92kDLfGk7f8y4rPBsxJ0c6nFPrN75OCJlG2/++IWhL3oQLUTIPRMqYieOGTv5WQbFpo8CWWfltJvOIuiz1ZxZytHBCY0MvKtIU6Papz00RRRyyIB75XQ== Laptop SSH Key"
    ];

    shell = pkgs.zsh;
  };

  services.vscode-server.enable = true;
  home-manager.users.mustachio = { pkgs, ... }: {
    home.packages = with pkgs; [
      zsh
      oh-my-zsh
      starship
      meslo-lgs-nf
    ];

    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
      };
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch -I nixos-config=/home/mustachio/config/machines/box1/configuration.nix";
      };
    };

    programs.starship = {
      enable = true;
    };

    programs.git = {
      enable = true;
      userName = "Mustachio";
      userEmail = "mustachio@dragonlegion.be";
    };

    home.stateVersion = "24.05";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

