let
  main = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDyLrBCA5c7OEX1Shziwq/jSoZTMeES1oaHt6Pibf/vLZaQf0EJQfFc41UUyHeYpLrgpQmy0r+Zwzq65zAz6Zo+wk6Hs1xZvaYf35jKsS/IXfkIU2TriRxYxXA4Mrh/tS3aWGMd7dO5/U6apGen2eVpb2S9mKxOpdrnU6vIMrRFqcNhcYTWEoy+fxXfNeUliiOXqT63ImOTLEudSWCGbmvO4ljEHGr9s1DqF6An0HvAhNRwlI1mR30oTcblfBX4qTDeB7svkBp+tpEREbSlU/2Vx6RO+fNMvBaqDQx0a4+ic5Udo6zbZCx/2+RM0eRFuk5R8sNuE6tULbF1FC5yNPNODKoRbqbYqqZLOYtrY6YV0C63Ixu8bY64/+4l9LBDacstQcn5Puj6ibqN2AM19TA+8imqfWVe1cX9sz/GZY/UBsxrR2X94l5jTNWkvN9KERVW+kYwyC4XMdZapA9EhD+u+I6Wd6mUeD4Z6m9D1LWGUT2mfQ7NQMFEWpwWw1ZHxx2ul7ACcbBZ21m56wNZxChgKaVh0yomGL7BKsEEehSRRm58hBvx9z7fSp92kDLfGk7f8y4rPBsxJ0c6nFPrN75OCJlG2/++IWhL3oQLUTIPRMqYieOGTv5WQbFpo8CWWfltJvOIuiz1ZxZytHBCY0MvKtIU6Papz00RRRyyIB75XQ==";
  users = [ main ];

  # /etc/ssh/ssh_host_ed25519_key.pub
  box2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILBm1C2I4zicLcsP5I+Wakr2WE43H7xPO/KO8M+W4Qpi root@nixos";
  systems = [ box2 ];
in
{
  "dragonlegion.be.age".publicKeys = [ box2 ];
  #"secret2.age".publicKeys = users ++ systems;
}
