{
  config,
  lib,
  ...
}:
let
  cfg = config.drlg.shell;
in
{
  options.drlg.shell = {
    enable = lib.mkEnableOption "shared shell configuration";

    sessionPath = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional PATH entries for user-installed binaries.";
    };

    rebuildCommand = lib.mkOption {
      type = lib.types.str;
      default = "nixos-rebuild switch";
      description = "Command exposed as the rebuild shell alias.";
    };

    ohMyPoshConfig = lib.mkOption {
      type = lib.types.path;
      default = ./monokai.omp.json;
      description = "oh-my-posh configuration file.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionPath = cfg.sessionPath;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "gitfast"
          "safe-paste"
        ];
      };

      shellAliases = {
        rebuild = cfg.rebuildCommand;
      };

      history.size = 10000;
    };

    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      configFile = cfg.ohMyPoshConfig;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
