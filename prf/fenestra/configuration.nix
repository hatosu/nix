{
  lib,
  inputs,
  nixosVersion,
  ...
}: {

  imports = let module = inputs.self.nixosModules; in [
    
    ./local/wsl.nix
    ./local/manage.nix
    ./local/host.nix
    ./local/network.nix

    module.pkg
    module.cli
    module.cmd
    module.warnings
    module.textfonts
  
  ];

  nixpkgs = { overlays = let overlay = inputs.self.overlays; in [

    overlay.additions
    overlay.modifications
    overlay.latest-packages
    overlay.stable-packages

  ];};

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = nixosVersion;

}
