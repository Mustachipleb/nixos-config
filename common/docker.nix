{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.drlg.docker;
in {
  options.services.drlg.docker = {
    enable = mkEnableOption "Docker";
    cdi = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Nvidia support for Docker";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon = mkIf cfg.cdi {
          settings = {
            features = {
              cdi = true;
              nvidia = true;
            };
          };
        };
      };
      daemon.settings = {
        hosts = [
          "unix:///var/run/docker.sock"
          "tcp://0.0.0.0:2375"
        ];
        features = mkIf cfg.cdi {
          cdi = true;
          nvidia = true;
        };
      };
      liveRestore = false;
    };
  };
}
