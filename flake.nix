{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      niri,
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      pkgs-args = {
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
      };
      pkgs-x86_64 = import nixpkgs (pkgs-args // { system = "x86_64-linux"; });

      specialArgs = {
        inherit inputs;
        util = import ./util.nix;
        outputs = self;
      };

      treefmtEval = treefmt-nix.lib.evalModule pkgs-x86_64 ./treefmt.nix;
    in
    {
      checks.x86_64-linux.style = treefmtEval.config.build.check self;
      formatter.x86_64-linux = treefmtEval.config.build.wrapper;

      devShells.x86_64-linux = import ./shells.nix { pkgs = pkgs-x86_64; };

      overlays.default = import ./overlays;

      nixosConfigurations = {
        moonrise = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./hive/common
            ./hive/moonrise
            {
              nixpkgs.overlays = [ niri.overlays.niri ];
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };

        sunset = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "aarch64-linux";
          modules = [
            ./hive/common
            ./hive/sunset
            { home-manager.extraSpecialArgs = specialArgs; }
          ];
        };
      };
    };
}
