{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.drlg.docker;
in {
  options.services.drlg.docker = {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon.settings = {
        hosts = [
          "unix:///var/run/docker.sock"
          "tcp://0.0.0.0:2375"
        ];
      };
      liveRestore = false;
    };
  };
}
