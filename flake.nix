{
  
  description = "Hatosu's NixOS flake.";

  inputs = {

    # default (new packages)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # fresh (newer packages)
    nixpkgs-fresh.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # latest (newest packages)
    nixpkgs-latest.url = "github:nixos/nixpkgs?ref=master";

    # stable (old packages)
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # pinned (wont update)
    nixpkgs-pinned.url = "github:nixos/nixpkgs/f83f99270023d739b4ab3fa51f39778165bb4920";

    impermanence = {
      url = "github:nix-community/impermanence/c7f5b394397398c023000cf843986ee2571a1fd7";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/8870dcaff63dfc6647fb10648b827e9d40b0a337";
    };

    home-manager = {
      url = "github:nix-community/home-manager/9ebaa80a227eaca9c87c53ed515ade013bc2bca9";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/67dc29be3036cc888f0b9d4f0a788ee0f6768700";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };

    nixvim = {
      url = "github:nix-community/nixvim/f4b0b81ef9eb4e37e75f32caf1f02d5501594811";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord/d5f2fbef2fad379190e0c7a0d2d2f12c4e4df034";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager/88ca377ff58b5c30a2879745829842554d4b21d5";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons&ref=507a6a4dfcf786e6b6691eeae1c96fc9f21a7d95";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft/f80c70946d3e27a466b8b9e65b24e36d571eac8b";
    };

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    nixos-wsl,
    nix-on-droid,
    plasma-manager,
    nixvim,
    nixcord,
    ...
  } @ inputs: let

    # read before changing: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    nixosVersion = "24.05";

    systems = ["x86_64-linux"];

    forAllSystems = nixpkgs.lib.genAttrs systems;

    shellpkgs = nixpkgs.legacyPackages.x86_64-linux;

    strings = import ./strings.nix;

    specialArgs = {inherit inputs strings nixosVersion;};

    homeManager = [
      home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = specialArgs;
          useGlobalPkgs = true;
          sharedModules = [
            inputs.plasma-manager.homeManagerModules.plasma-manager
            inputs.nixvim.homeManagerModules.nixvim
            inputs.nixcord.homeManagerModules.nixcord
          ];
        };
      }
    ];

  in {

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    overlays = import ./overlay {inherit inputs;};

    nixosModules = import ./module;

    devShells.x86_64-linux.default = import ./shell.nix {inherit shellpkgs;};

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

    nixosConfigurations = {

      laptop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = homeManager ++ [
          ./profile/laptop/configuration.nix
          inputs.disko.nixosModules.default
          inputs.impermanence.nixosModules.impermanence
        ];
      };

      wsl = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = homeManager ++ [
          ./profile/wsl/configuration.nix
          nixos-wsl.nixosModules.default
        ];
      };

      server1 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = homeManager ++ [
          ./profile/server1/configuration.nix
          inputs.disko.nixosModules.default
          inputs.impermanence.nixosModules.impermanence
        ];
      };

      temporary = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./profile/temporary/configuration.nix
          inputs.disko.nixosModules.default
        ];
      };

    };

    nixOnDroidConfigurations.android = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs { system = "aarch64-linux"; };
      modules = homeManager ++ [
        ./profile/android/configuration.nix
        {nix.registry.nixpkgs.flake = nixpkgs;}
      ];
    };

  };
}
