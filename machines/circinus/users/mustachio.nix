{
  config,
  pkgs,
  nixpkgs-unstable,
  system,
  ...
}:

{
  home.username = "mustachio";
  home.homeDirectory = "/home/mustachio";

  xdg.mimeApps.enable = true;

  drlg.shell = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Mustachio";
      email = "mustachio@dragonlegion.be";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";
}
