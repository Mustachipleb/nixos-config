{
  config,
  nixpkgs-unstable,
  pkgs,
  ...
}:

{
  environment.systemPackages = with nixpkgs-unstable; [
    gnome-tweaks

    # To provide video thumbnails in Nautilus
    ffmpeg-headless
    ffmpegthumbnailer
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Apply user monitor settings to login screen
  # by copying the user's monitors.xml to GDM's config directory
  systemd.services.applyUserMonitorSettings =
    let
      username = "mustachio";
      gdmConfigDir = "/var/lib/gdm/seat0/config";
    in
    {
      description = "Apply user monitor settings to GDM login screen";
      after = [
        "network.target"
        "systemd-user-sessions.service"
        "display-manager.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'echo \"Applying user monitor settings to GDM login screen\" && mkdir -p ${gdmConfigDir} && echo \"Created ${gdmConfigDir} directory\" && [ \"/home/${username}/.config/monitors.xml\" -ef \"${gdmConfigDir}/monitors.xml\" ] || cp /home/${username}/.config/monitors.xml ${gdmConfigDir}/monitors.xml && echo \"Copied monitors.xml to ${gdmConfigDir}/monitors.xml\" && chown gdm:gdm ${gdmConfigDir}/monitors.xml && echo \"Changed ownership of monitors.xml to gdm\"'";
      };
    };
}
