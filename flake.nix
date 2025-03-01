{
  
  description = "Re:Nix";

  inputs = {

    /* pkgs */
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-fresh.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-latest.url = "github:nixos/nixpkgs?ref=master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-pinned.url = "github:nixos/nixpkgs/5525603a0c65072af1cd24cd2750fa33749e4943";
    /* ---- */

    /* core */
    nixos-hardware.url = "github:NixOS/nixos-hardware/18e9f9753e9ae261bcc7d3abe15745686991fd30";
    impermanence.url = "github:nix-community/impermanence/4b3e914cdf97a5b536a889e939fb2fd2b043a170";
    disko.url = "github:nix-community/disko/15dbf8cebd8e2655a883b74547108e089f051bf0";
    home-manager.url = "github:nix-community/home-manager/bdf73272a8408fedc7ca86d5ea47192f6d2dad54";
    /* ---- */

    /* misc */
    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixcord.url = "github:kaylorben/nixcord/e759e621b5f5464278d1ac0e8a7239f98fa9b6da";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons&ref=ba3db5f76a6f352664d3398bdd11b09562831927";
    /* ---- */

    /* flws */
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "home-manager";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    /* ---- */

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    nixos-wsl,
    nix-on-droid,
    nixcord,
    ...
  } @ inputs: let

    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    string = import ./string.nix;
    specialArgs = {inherit inputs string nixosVersion;};

    homeManager = [
      home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = specialArgs;
          useGlobalPkgs = true;
          sharedModules = [
            inputs.nixcord.homeManagerModules.nixcord
          ];
        };
      }
    ];

    nixosVersion = "24.11";

  in {

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./ovr {inherit inputs;};
    nixosModules = import ./mod;

    nixosConfigurations = {

      benzi = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = homeManager ++ [
          ./prf/benzi/configuration.nix
          inputs.disko.nixosModules.default
          inputs.impermanence.nixosModules.impermanence
        ];
      };

      fenestra = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = homeManager ++ [
          ./prf/fenestra/configuration.nix
          nixos-wsl.nixosModules.default
        ];
      };

      jitaku = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = homeManager ++ [
          ./prf/jitaku/configuration.nix
          inputs.disko.nixosModules.default
          inputs.impermanence.nixosModules.impermanence
        ];
      };

      rinji = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./prf/rinji/configuration.nix
          inputs.disko.nixosModules.default
        ];
      };

    };

    nixOnDroidConfigurations.keitai = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs { system = "aarch64-linux"; };
      modules = homeManager ++ [
        ./prf/keitai/configuration.nix
        {nix.registry.nixpkgs.flake = nixpkgs;}
      ];
    };

  };
}
