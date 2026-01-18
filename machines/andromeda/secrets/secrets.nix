let
  mustachio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOw3bIQ+Ss8sjcYU5QyADiVs+ymCcRw0/4mi/Yk3LGxI mustachio@andromeda.dragonlegion.be";
  users = [ mustachio ];

  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQ1g+T5tIkfSOFV06zJ/VEUvAFxAXdNAkIz+wv1hzkt root@andromeda";
  systems = [ system ];
in
{
  # General secrets
}
