{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let

  FLAKE = "/home/hatosu/files/os/nix";

  HOST = "benzi";

in {

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs; in {
    
    settings = {
      
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      flake-registry = "";

      nix-path = config.nix.nixPath;

      trusted-substituters = ["https://cache.nixos.org"];
      extra-trusted-substituters = ["https://nix-community.cachix.org"];
      extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

      download-buffer-size = "9999999999";

      trusted-users = [
        "root"
        "@wheel"
      ];

    };

    gc = {
      dates = "daily";
      options = "--delete-older-than 1d";
      automatic = true;
    };

    optimise = {
      dates = ["daily"];
      automatic = true;
    };

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    channel.enable = false;

    package = pkgs.nixVersions.latest;

  };

  nixpkgs.config = {

    allowUnfree = true;
    allowBroken = false;
    allowInsecure = false;
    allowUnsupportedSystem = false;

    # whitelistedLicenses = with lib.licenses; [
    #   #unfreeRedistributable
    #   #issl
    # ];
    #
    # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    #   #"firmwareLinuxNonfree"
    # ];
    #
    # permittedInsecurePackages = [
    #   #"python-2.7.18.8"
    # ];
  
  };

  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

  system.activationScripts.channel-remove.text = ''
    if [ -d "/root/.nix-defexpr/channels" ]
    then
      rm -f /root/.nix-channels
      rm -rf /root/.nix-defexpr/channels
      mv -f /nix/var/nix/profiles/per-user/root/channels /tmp
    else
      printf ""
    fi
  '';

  programs.nh = {
    enable = true;
    package = pkgs.nh;
  };

  environment.shellAliases = {
    rebuild = "sudo clear && nh os switch -H ${HOST} ${FLAKE}";
    update = "sudo nix flake update --flake ${FLAKE}";
    develop = "sudo nix develop ${FLAKE}";
    cleanse = ''
      sudo nix-store --repair --verify --check-contents
      sudo nix-collect-garbage
      sudo nix store optimise
    '';
  };

}
