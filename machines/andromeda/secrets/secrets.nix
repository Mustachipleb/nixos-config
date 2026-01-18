let
  mustachio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOw3bIQ+Ss8sjcYU5QyADiVs+ymCcRw0/4mi/Yk3LGxI mustachio@andromeda.dragonlegion.be";
  users = [ mustachio ];

  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJTP6JX8x9+L/qr1RsbwIDyZJoJxzVevB2LqbIYL+Ar1 root@andromeda.dragonlegion.be";
  systems = [ system ];
in
{
  "sponsorblock.config.age".publicKeys = [ mustachio ];
  #"secret2.age".publicKeys = users ++ systems;
}
