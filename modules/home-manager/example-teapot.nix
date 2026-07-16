{
  config,
  lib,
  ...
}:
let
  cfg = config.drlg.examples.teapot;
in
{
  options.drlg.examples.teapot = {
    enable = lib.mkEnableOption "the example home-manager teapot module";

    aliasName = lib.mkOption {
      type = lib.types.str;
      default = "teatime";
      description = "Name of the shell alias created by the example module.";
    };

    message = lib.mkOption {
      type = lib.types.str;
      default = "Tea is ready.";
      description = "Message echoed by the alias created by the example module.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases.${cfg.aliasName} = "echo '${cfg.message}'";
  };
}
