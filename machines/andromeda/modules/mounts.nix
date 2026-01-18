{ pkgs, ... }:

let
  sshfsOptions = [
    "allow_other"
    "IdentityFile=/home/mustachio/.ssh/id_ed25519"
    "StrictHostKeyChecking=no"
    "UserKnownHostsFile=/dev/null"
    "Compression=no"
    "auto_cache"
    "x-systemd.automount"
    "noauto"
  ]; # as defined above
  mkSshfs = device: {
    device = device;
    fsType = "fuse.sshfs";
    options = sshfsOptions;
  };
in
{
  fileSystems."/home/mustachio/triangulum" = mkSshfs "mustachio@192.168.1.10:/home/mustachio";
  fileSystems."/home/mustachio/pinwheel" = mkSshfs "mustachio@192.168.1.11:/home/mustachio";
  fileSystems."/home/mustachio/pinwheel_downloads" =
    mkSshfs "mustachio@192.168.1.11:/mnt/qbittorrent_downloads";
  fileSystems."/home/mustachio/media" = mkSshfs "mustachio@192.168.1.112:/media";

  # TODO: Leads to emergency mode as the init systemd services can't finish successfully
  #  systemd.services.ldmtool-create-volume = {
  #    description = "Create LDM volume";
  #    wantedBy = [ "specialisation.target" ];
  #    before = [ "local-fs.target" ];
  #    after = [ "dev-mapper-ldm_vol_DESKTOP-7CMT1B6-Dg0_Volume1.device" ]; # Optional: wait for physical device if needed
  #    serviceConfig = {
  #      Type = "oneshot";
  #      ExecStart = "${pkgs.ldmtool}/bin/ldmtool create volume 8df9711e-2286-11ee-a0ef-244bfe93153b Volume1";
  #      RemainAfterExit = true;
  #    };
  #  };
  #
  #  fileSystems."/home/mustachio/zeta" = {
  #    # The mapping of the volume is NOT included in the config
  #    # so, if the mapper does not exist, run:
  #    # sudo ldmtool create volume 8df9711e-2286-11ee-a0ef-244bfe93153b Volume1
  #    # Assuming the GUID and volume are still the same, but they should be...
  #    device = "/dev/mapper/ldm_vol_DESKTOP-7CMT1B6-Dg0_Volume1";
  #    depends = [ "ldmtool-create-volume.service" ];
  #  };
}
