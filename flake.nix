{
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	  nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = inputs @ { home-manager, nixpkgs, nixpkgs-unstable, stylix, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations = {
      moonrise = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs pkgs-unstable; };
        modules = [
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          ./nixos
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dawn.imports = [ ./home/common.nix ./home/dawn.nix ];
            home-manager.extraSpecialArgs = { inherit pkgs pkgs-unstable; };
          }
        ];
      };
    };
  };
}
