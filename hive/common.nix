{ config, pkgs-unstable, ... }:
let
  ssh-keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMLmbjFirrZ6T8/Uj96/atn39JwpnEZJOZ5TufBtVMQ dawn@moonrise"
  ];
in {
  system.stateVersion = "24.05";

  boot.tmp.cleanOnBoot = true;

  users = {
    mutableUsers = false;
    users.root = {
      openssh.authorizedKeys.keys = ssh-keys;
    };

    users.dawn = {
      isNormalUser = true;
      home = "/home/dawn";
      extraGroups = [ "networkmanager" "video" "wheel" ];
      shell = pkgs-unstable.nushell;
      hashedPassword = "$y$j9T$O7TCsYTix3J1Fu2PCZ/Pp1$iOIT6e2tn2kdZNRz09UIy1QgaoWbwBNczZItsDuiAw9";
      openssh.authorizedKeys.keys = ssh-keys;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  age.secrets.tailscale-auth-key.file = ./tailscale-auth-key.age;
  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
    authKeyFile = config.age.secrets.tailscale-auth-key.path;
    extraUpFlags = [ "--ssh" ];
  };

  time.timeZone = "America/New_York";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}
