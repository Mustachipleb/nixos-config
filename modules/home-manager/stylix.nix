{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.drlg.stylix;
in
{
  options.drlg.stylix = {
    enableMonokaiOverrides = lib.mkEnableOption "Applies specific patches for the monokai base16 scheme";
  };

  config = lib.mkIf cfg.enableMonokaiOverrides {
    stylix.targets.spicetify.colors.override = {
      base04 = "f9cc6c"; # Make yellow great again
    };

    stylix.targets.vencord = {
      enable = true;
      colors.override = {
        base0B = "f9cc6c"; # Make yellow great again
      };
    };
  };
}
