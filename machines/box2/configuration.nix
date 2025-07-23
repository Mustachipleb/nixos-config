{ config, lib, pkgs, ... }:

let
  vars = import ./vars.nix;
  agenixVersion = "0.15.0";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      ../../common/ssh.nix
      ../../common/powermgmt.nix
      ../../common/docker.nix
      ../../common/network.nix
      ../../common/gpu/nvidia.nix
      ../../../dragonlegion.be/docker-compose.nix
      "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/${agenixVersion}.tar.gz"}/modules/age.nix"
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
    };
    grub = {
       efiSupport = true;
       #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
       device = "nodev";
    };
  };

  programs.nix-ld.enable = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  networking.hostName = "nixos-box2";
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.drlg = {
    docker = {
      enable = true;
      cdi = true;
      rootless = false;
    };
    powerManagement.enable = true;
    networking = {
      hostname = vars.hostName;
      ipAddress = vars.ipAddress;
      gateway = vars.gateway;
      allowedTCPPorts = [
        3098
        3099
        53
      ];
    };
    graphics.enable = true;
  };

  age.secrets."dragonlegion.be.age".file = ../../common/secrets/dragonlegion.be.age;

  users.users = {
    mustachio =
      let
        common = import ../../common/user/wheel.nix { inherit config pkgs vars; };
      in
      common // {
        home = "/home/mustachio";
      };
  };

  programs.zsh.enable = true;

  home-manager = {
    users = {
      mustachio =
        let
          common = import ../../common/home.nix { inherit config pkgs vars; };
        in
        common // {
          home.stateVersion = "24.11";
        };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    pkgs.sshfs
    git
    git-crypt
    compose2nix
    (pkgs.callPackage "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/${agenixVersion}.tar.gz"}/pkgs/agenix.nix" {})
  ];

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
  system.stateVersion = "24.11"; # Did you read the comment?

}

