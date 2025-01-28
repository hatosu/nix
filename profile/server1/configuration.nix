{
  inputs,
  lib,
  nixosVersion,
  ...
}: {

  imports = let module = inputs.self.nixosModules; in [

    ./local/hardware.nix
    ./local/disk.nix
    ./local/host.nix
    ./local/boot.nix
    ./local/impermanence.nix
    ./local/package.nix
    ./local/manage.nix
    ./local/network.nix

    module.pkg
    module.commands
    module.warnings
    module.cli
    module.neovim
    module.openssh
    module.minecraft

  ];

  nixpkgs = { overlays = let overlay = inputs.self.overlays; in [

    overlay.additions
    overlay.modifications
    overlay.fresh-packages
    overlay.latest-packages
    overlay.stable-packages
    overlay.pinned-packages
  
  ];};

  home-manager = {
    backupFileExtension = "backup";
    users = {
      "hatosu" = import ./home.nix;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = nixosVersion;

}
