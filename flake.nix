{
  
  description = "Re:Nix";

  inputs = {

    /* pkgs */
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-latest.url = "github:nixos/nixpkgs?ref=master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    /* ---- */

    /* core */
    nixos-hardware.url = "github:NixOS/nixos-hardware/ecaa2d911e77c265c2a5bac8b583c40b0f151726";
    /* ---- */
    
    /* misc */
    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    /* ---- */

    /* flws */
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    /* ---- */

  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    nixos-wsl,
    nix-on-droid,
    ...
  } @ inputs: let

    nixosVersion = "24.11";
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    specialArgs = {inherit inputs nixosVersion;};

  in {

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./ovr {inherit inputs;};
    nixosModules = import ./mod;

    nixosConfigurations = {

      benzi = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./prf/benzi/configuration.nix
        ];
      };

      fenestra = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./prf/fenestra/configuration.nix
          nixos-wsl.nixosModules.default
        ];
      };

      jitaku = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./prf/jitaku/configuration.nix
          inputs.impermanence.nixosModules.impermanence
        ];
      };

      rinji = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./prf/rinji/configuration.nix
        ];
      };

    };

    nixOnDroidConfigurations.keitai = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs { system = "aarch64-linux"; };
      modules = [
        ./prf/keitai/configuration.nix
        {nix.registry.nixpkgs.flake = nixpkgs;}
      ];
    };

  };
}
