{
  config,
  pkgs,
  lib,
  system,
  nixpkgs-unstable,
  nix-jetbrains-plugins,
  ...
}:

let
  cfg = config.drlg.jetbrains;

  mkJetbrainsIde =
    name: ideCfg:
    let
      pluginBase = nix-jetbrains-plugins.plugins.${system}.idea.${ideCfg.version};
      plugins = map (pluginName: pluginBase.${pluginName}) ideCfg.plugins;
    in
    nixpkgs-unstable.jetbrains.plugins.addPlugins ideCfg.package plugins;
in
{
  options.drlg.jetbrains = {
    enable = lib.mkEnableOption "Jetbrains IDEs";

    editors = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to install this JetBrains IDE.";
              };

              package = lib.mkOption {
                type = lib.types.package;
                default = nixpkgs-unstable.jetbrains.${name};
                defaultText = lib.literalExpression "nixpkgs-unstable.jetbrains.<name>";
                description = "JetBrains IDE package to install.";
              };

              version = lib.mkOption {
                type = lib.types.str;
                description = "JetBrains IDE version.";
              };

              plugins = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Plugin IDs to install for this IDE.";
              };
            };
          }
        )
      );
      default = { };
      description = "JetBrains IDEs to install, keyed by IDE package name.";
      example = lib.literalExpression ''
        {
          webstorm = {
            version = "2026.1.3";
            pluginIde = "idea";
            plugins = [
              "nix-idea"
              "org.jetbrains.junie"
              "zielu.gittoolbox"
              "com.intellij.ml.llm"
              "izhangzhihao.rainbow.brackets"
              "monokai-pro"
            ];
          };

          rider = {
            version = "2026.1.3";
            pluginIde = "idea";
            plugins = [
              "org.jetbrains.junie"
              "zielu.gittoolbox"
              "com.intellij.ml.llm"
              "izhangzhihao.rainbow.brackets"
              "monokai-pro"
            ];
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mapAttrsToList mkJetbrainsIde (
      lib.filterAttrs (_: ideCfg: ideCfg.enable) cfg.editors
    );
  };
}
