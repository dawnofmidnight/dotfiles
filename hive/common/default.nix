{ inputs, outputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.default
    ../../modules
    ./services.nix
    ./users.nix
  ];

  system.stateVersion = "24.11";

  boot.tmp.cleanOnBoot = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  nix = {
    channel.enable = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    registry = {
      pkgs.flake = inputs.nixpkgs;
      pkgs-unstable.flake = inputs.nixpkgs-unstable;
    };
    settings = {
      builders-use-substitutes = true;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      keep-outputs = true;
      trusted-users = [
        "@wheel"
        "root"
        "remote-build"
      ];
      use-xdg-base-directories = true;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ outputs.overlays.default ];
  };

  programs.command-not-found.enable = false;

  environment.sessionVariables = {
    DO_NOT_TRACK = 1;
    EDITOR = "hx";
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
}
