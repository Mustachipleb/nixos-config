{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  # Shorter name to access final settings a
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.services.drlg.fileShares;
  nasIpAddress = "192.168.1.112";
  baseMountOptions = [
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=60"
    "x-systemd.device-timeout=5s"
    "x-systemd.mount-timeout=5s"
    "uid=1000"
    "gid=100"
    "iocharset=utf8"
  ];
in
{
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.services.drlg.fileShares = {
    enable = mkEnableOption "File Shares";
    # object with booleans for each share
    shares = {
      media = mkOption {
        type = types.bool;
        default = false;
        description = "Enable media share";
      };
      backups = mkOption {
        type = types.bool;
        default = true;
        description = "Enable backups share";
      };
    };
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    # Add CIFS support
    environment.systemPackages = with pkgs; [
      cifs-utils
    ];

    # Enable CIFS kernel module
    boot.supportedFilesystems = [ "cifs" ];

    fileSystems."/mnt/media" = mkIf cfg.shares.media {
      device = "//${nasIpAddress}/media";
      fsType = "cifs";
      options = baseMountOptions ++ [
        "credentials=${config.age.secrets.synologySmbCredentials.path}"
      ];
    };

    fileSystems."/mnt/backups" = mkIf cfg.shares.backups {
      device = "//${nasIpAddress}/backups";
      fsType = "cifs";
      options = baseMountOptions ++ [
        "credentials=${config.age.secrets.synologySmbCredentials.path}"
      ];
    };
  };
}
