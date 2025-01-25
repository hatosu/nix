let pkgs = import <nixpkgs> {};
  SHELL = "#!/usr/bin/env bash";
  DIR = "nix";
  GIT = "https://github.com/hatosu/${DIR}";
in pkgs.writeShellScriptBin "install" ''
  ${SHELL}
  sudo nix --experimental-features "nix-command flakes" run nixpkgs#git -- clone ${GIT} /tmp/${DIR}
  lsblk && printf ""
  printf "drive to use: " >&2
  read -r _DRIVE
  sudo sgdisk -Z "/dev/$_DRIVE"
  sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/${DIR}/profile/temporary/disk.nix --arg device '"/dev/$_DRIVE"'
  sudo nixos-generate-config --no-filesystems --root /mnt
  sudo rm -f /tmp/${DIR}/flake.lock
  sudo rm -f /mnt/etc/nixos/configuration.nix
  sudo cp -rf /tmp/${DIR}/* /mnt/etc/nixos
  sudo mv -f /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/profile/temporary/hardware.nix
  sudo mkdir /persist
  sudo cp -rf /mnt/etc/nixos /persist
  sudo nixos-install --root /mnt --flake /mnt/etc/nixos#temporary
''
