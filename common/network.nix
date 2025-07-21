{ lib, pkgs, config, ... }:
with lib;
let
  # Shorter name to access final settings a
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.services.drlg.networking;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.services.drlg.networking = {
    hostname = mkOption {
      type = types.str;
      default = null;
    };
    customNameServers = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    networkInterface = mkOption {
      type = types.str;
      default = "eth0";
    };
    ipAddress = mkOption {
      type = types.str;
      default = null;
    };
    ipPrefixLength = mkOption {
      type = types.int;
      default = 24;
    };
    allowedTCPPorts = mkOption {
      type = types.listOf types.int;
      default = [22];
    };
    allowedUDPPorts = mkOption {
      type = types.listOf types.int;
      default = [];
    };
    gateway = mkOption {
      type = types.str;
      default = null;
    };
  };

  config = {
    #system.autoUpgrade.dates = "${updateDay} *-*-* 00:00:00";
    networking = {
      hostName = cfg.hostname;
      nameservers = cfg.customNameServers ++ [
        "1.1.1.1"
        "1.0.0.1"
      ];
      interfaces = {
        "${cfg.networkInterface}" = {
          ipv4 = {
            addresses = [
              {
                address = cfg.ipAddress;
                prefixLength = cfg.ipPrefixLength;
              }
            ];
          };
        };
      };
      defaultGateway = {
        address = cfg.gateway;
        interface = cfg.networkInterface;
      };
      firewall.enable = true;
      firewall.allowedTCPPorts = cfg.allowedTCPPorts;
      firewall.allowedUDPPorts = cfg.allowedUDPPorts;
    };
  };
}
