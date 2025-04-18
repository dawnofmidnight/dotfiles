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
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "git+https://git.lix.systems/lix-project/nixos-module?ref=release-2.92";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      lix,
      niri,
      nixpkgs,
      nixpkgs-unstable,
      treefmt-nix,
      ...
    }@inputs:
    let
      pkgs-args = {
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
      };
      pkgs-x86_64 = import nixpkgs (pkgs-args // { system = "x86_64-linux"; });
      pkgs-unstable-x86_64 = import nixpkgs-unstable (pkgs-args // { system = "x86_64-linux"; });
      pkgs-unstable-aarch64 = import nixpkgs-unstable (pkgs-args // { system = "aarch64-linux"; });

      generalSpecialArgs = {
        inherit inputs;
        util = import ./util.nix;
        outputs = self;
      };

      treefmtEval = treefmt-nix.lib.evalModule pkgs-x86_64 ./treefmt.nix;

      collectFlakeInputs =
        input:
        [ input ] ++ builtins.concatMap collectFlakeInputs (builtins.attrValues (input.inputs or { }));

      extraDeps = builtins.concatMap collectFlakeInputs (builtins.attrValues inputs) ++ [
        self.checks.x86_64-linux.style
        self.formatter.x86_64-linux
      ];
    in
    {
      checks.x86_64-linux.style = treefmtEval.config.build.check self;
      formatter.x86_64-linux = treefmtEval.config.build.wrapper;

      devShells.x86_64-linux = import ./shells.nix {
        pkgs = pkgs-x86_64;
        pkgs-unstable = pkgs-unstable-x86_64;
      };

      overlays.default = import ./overlays;

      nixosConfigurations = {
        moonrise = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./hive/common
            ./hive/moonrise
            lix.nixosModules.default
            {
              nixpkgs.overlays = [ niri.overlays.niri ];
              home-manager.extraSpecialArgs = specialArgs;
              system.extraDependencies = extraDeps;
            }
          ];
          specialArgs = generalSpecialArgs // {
            pkgs-unstable = pkgs-unstable-x86_64;
          };
        };

        sunset = nixpkgs.lib.nixosSystem rec {
          system = "aarch64-linux";
          modules = [
            ./hive/common
            ./hive/sunset
            lix.nixosModules.default
            { home-manager.extraSpecialArgs = specialArgs; }
          ];
          specialArgs = generalSpecialArgs // {
            pkgs-unstable = pkgs-unstable-aarch64;
          };
        };
      };
    };
}
