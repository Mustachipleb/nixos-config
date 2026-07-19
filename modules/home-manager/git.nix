{
  config,
  lib,
  ...
}:
let
  cfg = config.drlg.git;
in
{
  options.drlg.git = {
    enable = lib.mkEnableOption "shared git configuration";
    enableGithub = lib.mkEnableOption "enable github integration";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user.name = "Nicolas Van Damme";
        user.email = "mustachio@dragonlegion.be";
      };
    };

    programs.gh = lib.mkIf cfg.enableGithub {
      enable = true;
      gitCredentialHelper = {
        enable = true;
      };
    };
  };
}
