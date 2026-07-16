{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.drlg.examples.teapot;
in
{
  options.drlg.examples.teapot = {
    enable = lib.mkEnableOption "the example teapot module";

    message = lib.mkOption {
      type = lib.types.str;
      default = "The teapot is warm.";
      description = "Message written to /etc/teapot-message when the example module is enabled.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.lolcat ];

    environment.etc."teapot-message".text = ''
      ${cfg.message}
    '';
  };
}
