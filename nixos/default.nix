{ inputs, pkgs-unstable, ... }: {
  imports = [
    ./config.nix
    ./hardware-configuration.nix
    ./system.nix
  ];

  system.stateVersion = "24.05";

  users = {
    mutableUsers = false;
    users.dawn = {
      isNormalUser = true;
      home = "/home/dawn";
      extraGroups = [ "networkmanager" "video" "wheel" ];
      shell = pkgs-unstable.nushell;
      hashedPassword = "$y$j9T$O7TCsYTix3J1Fu2PCZ/Pp1$iOIT6e2tn2kdZNRz09UIy1QgaoWbwBNczZItsDuiAw9";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    registry = {
      pkgs.flake = inputs.nixpkgs;
      pkgs-unstable.flake = inputs.nixpkgs-unstable;
    };

    settings = {
      experimental-features = [ "flakes" "nix-command" "pipe-operator" ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
