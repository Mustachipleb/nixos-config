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

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.mirroredBoots = [
    {
      devices = [ "/dev/disk/by-uuid/0799-1261" ];
      path = "/boot-fallback";
    }
  ];

  boot.initrd.systemd.enable = true;

  boot.swraid = {
    enable = true;
    mdadmConf = ''
      ARRAY /dev/md0 level=raid1 num-devices=2 metadata=1.2 \
        name=nixos:0 UUID=dbd608bd:f58098d3:00def587:19cb4139 \
        devices=/dev/disk/by-partuuid/b317d762-ff3b-4431-9635-87473c64d867,/dev/disk/by-partuuid/9ba981b4-ab2a-44b5-8c24-7937d4d1d79d
    '';
  };

  networking.hostName = "condor"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  programs.zsh.enable = true;

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = false;
    };
    daemon.settings = {
      features.cdi = true;
      hosts = [
        "unix:///var/run/docker.sock"
        "tcp://0.0.0.0:2375"
      ];
    };
  };
  hardware.nvidia-container-toolkit.enable = true;

  # TODO: Include the script in the repo
  systemd.services.docker-backup = {
    description = "Daily Docker Backup";
    script = ''
      /home/mustachio/sync-docker.sh
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.timers.docker-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 05:00:00";
      Persistent = false;
      Unit = "docker-backup.service";
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOw3bIQ+Ss8sjcYU5QyADiVs+ymCcRw0/4mi/Yk3LGxI mustachio@andromeda.dragonlegion.be"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mustachio = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      nh
      git
      screen
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOw3bIQ+Ss8sjcYU5QyADiVs+ymCcRw0/4mi/Yk3LGxI mustachio@andromeda.dragonlegion.be"
    ];

    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [ hdparm ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };
  programs.ssh.startAgent = true;

  drlg.powerManagement = {
    enable = true;

    preventSleep = true;
    preventHddSpindown = true;
    disableUsbAutosuspend = true;

    disablePowertopAutoTune = true;
    disableTlp = true;
  };

  drlg.sshfs = {
    enable = true;
    identityFile = "/home/mustachio/.ssh/id_ed25519";
    mounts = {
      "/mnt/backups" = {
        host = "192.168.1.112";
        user = "mustachio";
        path = "/Backups";
      };
      "/mnt/temp-qbit" = {
        host = "192.168.1.11";
        user = "mustachio";
        path = "/mnt/qbittorrent_downloads";
      };
    };
  };

  drlg.nfs = {
    enable = true;
    mounts = {
      "/mnt/synology" = {
        host = "192.168.1.112";
        path = "/volume1/media";
      };
    };
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      8123 # Home assistant
    ];
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

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
  system.stateVersion = "26.05"; # Did you read the comment?

}
