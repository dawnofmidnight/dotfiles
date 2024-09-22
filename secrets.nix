let
  dawn-moonrise = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMLmbjFirrZ6T8/Uj96/atn39JwpnEZJOZ5TufBtVMQ dawn@moonrise";
  
  moonrise = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9oVjmn+enD/3N/enDlms6vd4UOP6FJtt0SsMYiMcqE root@moonrise";
  sunset = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFA3s3TKZjjrzAXNFu70+rmUwhwJqzRLaCrgxSg+JHe root@sunset";

  users = [ dawn-moonrise ];
  hosts = [ moonrise sunset ];
in {
  "hive/tailscale-auth-key.age".publicKeys = hosts;
}
