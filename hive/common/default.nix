{ inputs, outputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.default
    inputs.lix.nixosModules.default
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
    registry.pkgs.flake = inputs.nixpkgs;
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

  system.rebuild.enableNg = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
}
