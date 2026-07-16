{
  config,
  pkgs,
  vars,
  ...
}:

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
      rebuild = "sudo nixos-rebuild switch --flake /home/${vars.primaryUser}/nixos-config#${vars.machineName}";
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Mustachio";
      email = "mustachio@dragonlegion.be";
    };
  };

  programs.ssh = {
    enable = true;
    settings."*".AddKeysToAgent = "yes";
  };
}
