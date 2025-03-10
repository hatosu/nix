{ pkgs ? import <nixpkgs> {} }: pkgs.writeShellScriptBin "install" ''

  sudo nix \
    --experimental-features \
    "nix-command flakes" \
    run nixpkgs#git -- \
    clone https://github.com/hatosu/nix /tmp/nix

  clear && lsblk && printf ""
  printf "drive to use: " >&2
  read -r _DRIVE

  sudo sgdisk -Z "/dev/$_DRIVE"

  sudo nix \
    --experimental-features \
    "nix-command flakes" \
    run github:nix-community/disko -- \
    --mode disko /tmp/nix/prf/rinji/disk.nix \
    --arg device '"/dev/$_DRIVE"'

  sudo nixos-generate-config \
    --no-filesystems --root /mnt

  sudo rm -f /tmp/nix/flake.lock
  sudo rm -f /mnt/etc/nixos/configuration.nix
  sudo cp -rf /tmp/nix/* /mnt/etc/nixos
  sudo mv -f /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/prf/rinji/hardware.nix
  sudo mkdir /persist
  sudo cp -rf /mnt/etc/nixos /persist

  sudo nixos-install --root /mnt --flake /mnt/etc/nixos#rinji

''
