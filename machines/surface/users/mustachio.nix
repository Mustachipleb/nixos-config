{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.mustachio = { pkgs, ... }: {
    home.packages = with pkgs; [
      zsh
      starship
      meslo-lgs-nf
    ];

    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
      };
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch -I nixos-config=/home/mustachio/nixos-config/machines/surface/configuration.nix";
      };
    };

    programs.starship = {
      enable = true;
    };

    programs.git = {
      enable = true;
      userName = "Mustachio";
      userEmail = "mustachio@dragonlegion.be";
    };

    home.stateVersion = "24.05";
  };
}

