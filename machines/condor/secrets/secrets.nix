let
  mustachio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM97L0JMmvO4dk+OOAoHNy7aLgG5J3j6uUVDY3hJaV4x condor@dragonlegion.be";
  users = [ mustachio ];

  # /etc/ssh/ssh_host_ed25519_key.pub
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKmFYbcul5RlhaazPD0Dek12OIlZTvuGnuqmZoqhVW0 root@nixos-temp";
  systems = [ system ];
in
{
  "mysql.age".publicKeys = [
    mustachio
    system
  ];
}
