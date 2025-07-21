{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.drlg.docker;
  # sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update
  unstable = import <nixos-unstable> { config = {}; };
in {
  options.services.drlg.docker = {
    enable = mkEnableOption "Docker";
    cdi = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Nvidia support for Docker";
    };
    rootless = mkOption {
      type = types.bool;
      default = false;
      description = "Enable rootless Docker mode";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      package = unstable.docker;
      # trace = builtins.trace "Using Docker version: ${unstable.docker_27.version}" null;
      rootless = {
        enable = cfg.rootless;
        package = unstable.docker;
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
