{ config, pkgs, vars, ... }:

{
  home.packages = with pkgs; [
    zsh
    oh-my-zsh
    starship
    meslo-lgs-nf
  ];

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
    };
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch -I nixos-config=/home/${vars.primaryUser}/nixos-config/machines/${vars.machineName}/configuration.nix";
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

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
