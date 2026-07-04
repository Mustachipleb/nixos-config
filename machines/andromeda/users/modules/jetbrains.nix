{
  config,
  pkgs,
  system,
  nixpkgs-unstable,
  nix-jetbrains-plugins,
  ...
}:

let
  ideaVersion = "2026.1.3";

  ideaPluginBase = nix-jetbrains-plugins.plugins.${system}.idea.${ideaVersion};
  webstormPlugins = map (p: ideaPluginBase.${p}) [
    "nix-idea"
    "org.jetbrains.junie"
    "zielu.gittoolbox"
    "com.intellij.ml.llm"
    "izhangzhihao.rainbow.brackets"
    "monokai-pro"
  ];
  riderPlugins = map (p: ideaPluginBase.${p}) [
    "org.jetbrains.junie"
    "zielu.gittoolbox"
    "com.intellij.ml.llm"
    "izhangzhihao.rainbow.brackets"
    "monokai-pro"
  ];
in
{
  home.packages = with nixpkgs-unstable; [
    (jetbrains.plugins.addPlugins jetbrains.webstorm webstormPlugins)
    (jetbrains.plugins.addPlugins jetbrains.rider riderPlugins)
  ];
}
