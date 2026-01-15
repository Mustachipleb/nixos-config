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
}
