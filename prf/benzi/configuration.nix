{
  inputs,
  nixosVersion,
  ...
}: {

  imports = let
    module = inputs.self.nixosModules;
  in [

    # local modules
    ./local/disk.nix
    ./local/hardware.nix
    ./local/boot.nix
    ./local/host.nix
    ./local/network.nix
    ./local/manage.nix

    # global modules
    module.cli
    module.pkg
    module.cmd
    module.pipewire
    module.textfonts
    module.hotkeys
    module.warnings

  ];

  nixpkgs = {
    overlays = let
      overlay = inputs.self.overlays;
    in [
      overlay.additions
      overlay.modifications
      overlay.latest-packages
      overlay.stable-packages
    ];
  };

  system.stateVersion = nixosVersion;

}
