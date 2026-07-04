{ config, pkgs, ... }:

{
  home = {
    sessionPath = [
      "/home/mustachio/.npm-global/bin"
    ];
  };

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
      rebuild = "nix run /home/mustachio/nixos-config/machines/andromeda#deploy-andromeda";
    };
    history.size = 10000;
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = ./monokai.omp.json;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
