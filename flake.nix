{
  inputs = {
    agenix.url = "github:ryantm/agenix";
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs = {
        stable.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ { self, agenix, colmena, home-manager, lix-module, nixpkgs, nixpkgs-unstable }:
  let
    system = "x86_64-linux";
    
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ self.overlays.default ];
    };

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    util = import ./util.nix;
    special = { inherit inputs pkgs-unstable system util; };

    pin-nixpkgs = {
      nix = {
        registry = {
          pkgs.flake = inputs.nixpkgs;
          pkgs-unstable.flake = inputs.nixpkgs-unstable;
        };

        settings = {
          auto-optimise-store = true;
          experimental-features = [ "flakes" "nix-command" "pipe-operator" ];
          trusted-users = [ "root" "dawn" ];
        };

        gc = {
          automatic = true;
          options = "--delete-older-than 7d";
        };
      };
    };

    colmena-config = {
      meta = {
        nixpkgs = pkgs;
        specialArgs = special;
      };

      defaults = {
        imports = [
          agenix.nixosModules.default
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          pin-nixpkgs
          ./hive/common.nix
        ];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = special;
        };
      };

      moonrise = {
        imports = [ ./hive/moonrise ];
        deployment = {
          allowLocalDeployment = true;
          targetHost = null;
        };
        home-manager.users.dawn.imports = [
          ./home
          ./home/moonrise.nix
          ./modules/home-manager
        ];
      };

      sunset = {
        imports = [ ./hive/sunset ];
        deployment = {
          allowLocalDeployment = false;
          targetHost = "165.22.32.14";
        };
        home-manager.users.dawn.imports = [
          ./home
          ./home/sunset.nix
          ./modules/home-manager
        ];
      };
    };

    colmena-hive = colmena.lib.makeHive colmena-config;
  in {
    devShells.${system} = import ./shells.nix { inherit pkgs pkgs-unstable; };
    overlays.default = import ./overlays;
    
    colmena = colmena-config;
    nixosConfigurations = {
      inherit (colmena-hive.nodes) moonrise sunset;
    };
  };
}
