{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.drlg.sshfs;

  mkSshfsMount =
    mount:
    let
      identityFile = if mount.identityFile != null then mount.identityFile else cfg.identityFile;
    in
    {
      device = "${mount.user}@${mount.host}:${mount.path}";
      fsType = "fuse.sshfs";
      options =
        cfg.defaultOptions
        ++ [
          "IdentityFile=${identityFile}"
        ]
        ++ mount.extraOptions;
    };
in
{
  options.drlg.sshfs = {
    enable = lib.mkEnableOption "Enable SSHFS";

    identityFile = lib.mkOption {
      type = lib.types.str;
      description = "Default SSH identity file used for SSHFS mounts.";
    };

    defaultOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "allow_other"
        "StrictHostKeyChecking=no"
        "UserKnownHostsFile=/dev/null"
        "Compression=no"
        "auto_cache"
        "x-systemd.automount"
        "noauto"
      ];
      description = "Default mount options used for all SSHFS mounts.";
    };

    mounts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            host = lib.mkOption {
              type = lib.types.str;
              description = "SSH host or IP address.";
            };

            user = lib.mkOption {
              type = lib.types.str;
              default = "mustachio";
              description = "SSH user.";
            };

            path = lib.mkOption {
              type = lib.types.str;
              description = "Remote path to mount.";
            };

            identityFile = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Optional per-mount identity file.";
            };

            extraOptions = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Additional SSHFS options for this mount.";
            };
          };
        }
      );
      default = { };
      description = "SSHFS mounts keyed by local mount point.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sshfs
    ];

    fileSystems = lib.mapAttrs (_mountPoint: mount: mkSshfsMount mount) cfg.mounts;
  };
}
