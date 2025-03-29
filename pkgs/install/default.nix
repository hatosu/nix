{ pkgs ? import <nixpkgs> {} }: let

  disko_version = "0d8c6ad4a43906d14abd5c60e0ffe7b587b213de";
  
in pkgs.writeShellScriptBin "install" ''

  sudo nix \
    --experimental-features \
    "nix-command flakes" \
    run nixpkgs#git -- \
    clone https://github.com/hatosu/nix /tmp/nix

  sudo nixos-generate-config \
    --root /mnt --no-filesystems

  sudo rm -f /mnt/etc/nixos/configuration.nix
  sudo cp -rf /tmp/nix/* /mnt/etc/nixos
  sudo mv -f /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/prf/rinji/hardware.nix

  clear && lsblk && printf ""
  printf "drive to use: " >&2
  read -r _DRIVE
  sudo sgdisk -Z "/dev/$_DRIVE"

  sudo nix --experimental-features 'nix-command flakes' \
    run 'github:nix-community/disko/${disko_version}#disko-install' -- \
    --write-efi-boot-entries --flake \
    "/mnt/etc/nixos#rinji" \
    --disk main "/dev/$_DRIVE"

''
