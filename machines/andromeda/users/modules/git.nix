{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Nicolas Van Damme";
      user.email = "mustachio@dragonlegion.be";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };
}
