{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.drlg.nfs;

  mkNfsMount =
    mount:
    {
      device = "${mount.host}:${mount.path}";
      fsType = "nfs";
    }
    // lib.optionalAttrs (cfg.defaultOptions != null) {
      options = cfg.defaultOptions;
    };
in
{
  options.drlg.nfs = {
    enable = lib.mkEnableOption "Enable NFS";

    defaultOptions = lib.mkOption {
      type = lib.types.nullOr (lib.types.nonEmptyListOf lib.types.nonEmptyStr);
      default = null;
      description = "Default mount options used for all NFS mounts.";
    };

    mounts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            host = lib.mkOption {
              type = lib.types.str;
              description = "host or IP address.";
            };

            path = lib.mkOption {
              type = lib.types.str;
              description = "Remote path to mount.";
            };
          };
        }
      );
      default = { };
      description = "NFS mounts keyed by local mount point.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = [ "nfs" ];

    fileSystems = lib.mapAttrs (_mountPoint: mount: mkNfsMount mount) cfg.mounts;
  };
}
