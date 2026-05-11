{
  config,
  pkgs,
  system,
  nix-jetbrains-plugins,
  ...
}:
{
  imports = [
    ./home.nix
  ];
}
