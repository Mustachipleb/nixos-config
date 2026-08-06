{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "intel_idle.max_cstate=1"
    "processor.max_cstate=1"
  ];

  services.fstrim.enable = true;

  networking.hostName = "circinus"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      8280
      8281
      2375
      25565
    ];
  };

  programs.zsh.enable = true;

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      hosts = [
        "unix:///var/run/docker.sock"
      ];
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOw3bIQ+Ss8sjcYU5QyADiVs+ymCcRw0/4mi/Yk3LGxI mustachio@andromeda.dragonlegion.be"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mustachio = {
    isNormalUser = true;
    description = "Mustachio";
    extraGroups = [
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOw3bIQ+Ss8sjcYU5QyADiVs+ymCcRw0/4mi/Yk3LGxI mustachio@andromeda.dragonlegion.be"
    ];

    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    wget
    git
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };
  programs.ssh.startAgent = true;

  # TODO: Decommission samba in favour of a fuse mount
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        security = "user";
        "hosts allow" = "192.168.1. 192.168.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "ntlm auth" = true;
      };

      home = {
        path = "/home/mustachio";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "mustachio";
        "force group" = "users";
      };
    };
  };

  systemd.services.compose = {
    enable = false; # TODO: Rework needed
    script = ''
      docker compose -f /home/mustachio/docker/compose.yml up --remove-orphans
    '';
    wantedBy = [ "multi-user.target" ];
    # If you use podman
    # after = ["podman.service" "podman.socket"];
    # If you use docker
    after = [
      "docker.service"
      "docker.socket"
    ];
    path = [ pkgs.docker ];
  };

  drlg.powerManagement = {
    enable = true;

    preventSleep = true;
    preventHddSpindown = false;
    disableUsbAutosuspend = true;

    disablePowertopAutoTune = false;
    disableTlp = true;
    restrictCpuCStates = true;
  };

  # Persistent journal so logs survive reboots
  services.journald.extraConfig = "Storage=persistent";

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
