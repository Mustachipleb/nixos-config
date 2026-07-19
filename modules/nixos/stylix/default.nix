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
    enable = lib.mkEnableOption "Enable stylix";
    autoEnable = lib.mkEnableOption "Automatically enable stylix integrations with applications";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = cfg.autoEnable;
      polarity = "dark";
      base16Scheme = ./base16-monokai.yaml;
      fonts = {
        monospace = {
          package = pkgs.fira-code;
          name = "Fira Code";
        };
      };
    };
  };
}
