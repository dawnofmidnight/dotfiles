let
  dawn-moonrise = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMLmbjFirrZ6T8/Uj96/atn39JwpnEZJOZ5TufBtVMQ dawn@moonrise";
  
  moonrise = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9oVjmn+enD/3N/enDlms6vd4UOP6FJtt0SsMYiMcqE root@moonrise";
  sunset = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMJ5oAX48soU4T3N5yaWCjJY3EgbE9/zCmUfW1PUHbi root@sunset";

  users = [ dawn-moonrise ];
  hosts = [ moonrise sunset ];
in {
  "hive/tailscale-auth-key.age".publicKeys = hosts;
}
