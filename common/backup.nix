{ lib, pkgs, config, ... }:
with lib;
let
  # Shorter name to access final settings a
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.services.drlg.backups;
  rsync = pkgs.rsync;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.services.drlg.backups = {
    enable = mkEnableOption "Automated Backups";

    paths = {
      include = mkOption {
        type = types.listOf types.str;
        default = [];
      };
      exclude = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };

    cron = mkOption {
      type = types.str;
      default = "0 0 * * *";
    };

    mount = {
      path = mkOption {
        type = types.str;
        default = "/mnt/backups";
      };
      ipAdress = mkOption {
        type = types.str;
        default = null; # 192.168.0.238
      };
    }
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    fileSystems.${cfg.mount.path} = {
      device = "//${cfg.mount.ipAddress}/backups";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/home/mustachio/config/machines/box1/smb-backups-credentials"];
    };

    systemd.timers.backup = {
      description = "Automated Backup Timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.cron;
        Persistent = true;
      };
    };

    systemd.services.backup = {
      description = "Automated Backup Service";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${rsync}/bin/rsync -av --delete ${concatStringsSep " " cfg.paths.include} ${cfg.mount.path} ${optionalString (cfg.paths.exclude != []) "--exclude "}${concatStringsSep " --exclude " cfg.paths.exclude}
        '';
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
