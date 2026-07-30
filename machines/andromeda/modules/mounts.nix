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
  # System brokey
  # fileSystems."/home/mustachio/triangulum" = mkSshfs "mustachio@192.168.1.10:/home/mustachio";
  fileSystems."/home/mustachio/mayall" = {
    device = "/dev/disk/by-uuid/11cd9994-37fa-402e-83b9-8321d51b4acc";
    fsType = "ext4";
  };

  fileSystems."/mnt/pinwheel" = mkSshfs "mustachio@192.168.1.11:/home/mustachio";
  fileSystems."/mnt/pinwheel_downloads" = mkSshfs "mustachio@192.168.1.11:/mnt/qbittorrent_downloads";
  fileSystems."/mnt/media" = mkSshfs "mustachio@192.168.1.112:/media";
  fileSystems."/mnt/backups" = mkSshfs "mustachio@192.168.1.112:/Backups";
  fileSystems."/mnt/circinus" = mkSshfs "mustachio@192.168.1.12:/home/mustachio";
  fileSystems."/mnt/condor" = mkSshfs "mustachio@192.168.1.20:/home/mustachio";
}
