{ pkgs ? import <nixpkgs> {} }: let
# inspo: https://github.com/eh8/chenglab/blob/1f7dbf56e7818346f2be2ba14e865f2528984ebb/install.sh

  nixos = ''
    echo -e "
      nixos usb detected
      \n\033[1;31m**Warning:** script is irreversible & will prepare system for a nixos installation\033[0m
    "
    read -n 1 -s -r -p "press any key to continue, or Ctrl+C to abort..."
    clear
    clear && lsblk && printf ""
    printf "drive to use: " >&2
    read -r DISK
    sgdisk -Z "/dev/$DISK"
    wipefs --all "/dev/$DISK"
    BOOT_PART="/dev/$DISKp1"
    NIX_PART="/dev/$DISKp2"
    set +e
    umount -R /mnt
    cryptsetup close cryptroot
    set -e
    parted $DISK -- mklabel gpt
    parted $DISK -- mkpart ESP fat32 1MiB 512MiB
    parted $DISK -- set 1 boot on
    parted $DISK -- mkpart Nix 512MiB 100%
    cryptsetup -q -v luksFormat $NIX_PART
    cryptsetup -q -v open $NIX_PART cryptroot
    mkfs.fat -F32 -n boot $BOOT_PART
    mkfs.ext4 -F -L nix -m 0 /dev/mapper/cryptroot
    sleep 2
    mount -t tmpfs none /mnt
    mkdir -pv /mnt/{boot,nix,etc/ssh,var/{lib,log}}
    mount /dev/disk/by-label/boot /mnt/boot
    mount /dev/disk/by-label/nix /mnt/nix
    mkdir -pv /mnt/nix/{secret/initrd,persist/{etc/ssh,var/{lib,log}}}
    mount -o bind /mnt/nix/persist/var/log /mnt/var/log
    nixos-generate-config --root /mnt
    rm -f /mnt/etc/nixos/configuration.nix
    cp -rf /tmp/nix/* /mnt/etc/nixos
    mv -f /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/prf/rinji/hardware.nix
    cp -f /mnt/etc/nixos/prf/rinji/hardware.nix /mnt/etc/nixos/prf/benzi/local/
    nixos-install --root /mnt --flake /mnt/etc/nixos#rinji
  '';

  macos = ''
    echo -e "
      macos detected\n
      \033[1;31m**Warning:** preparing for nix-darwin installation\033[0m
    "
    read -n 1 -s -r -p "press any key to continue, or Ctrl+C to abort..."
    echo -e "\n\033[1mInstalling Xcode...\033[0m"
    if [[ -e /Library/Developer/CommandLineTools/usr/bin/git ]]; then
      echo -e "\033[32mXcode already installed.\033[0m"
    else
      touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
      PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
      softwareupdate -i "$PROD" --verbose
      echo -e "\033[32mXcode installed successfully.\033[0m"
    fi
    echo -e "\n\033[1mInstalling Rosetta...\033[0m"
    softwareupdate --install-rosetta --agree-to-license
    echo -e "
      \033[32mRosetta installed successfully.\033[0m
      \n\033[1mInstalling Nix...\033[0m
    "
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    echo -e "
      \n\033[1;32mAll steps completed successfully. nix-darwin is now ready to be installed.\033[0m\n
      To install nix-darwin configuration, run the following commands:\n
      \033[1m. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh\033[0m\n
      \033[1mnix run nix-darwin -- switch --flake github:eh8/chenglab#mac1chng\033[0m\n
      Remember to add the new host public key to sops-nix!
    "
  '';

in pkgs.writeShellScriptBin "install" ''
  #!/bin/sh
  set -e -u -o pipefail
  sudo script -c "
    nix \
      --experimental-features \
      "nix-command flakes" \
      run nixpkgs#git -- \
      clone https://github.com/hatosu/nix /tmp/nix
    if [ "$(uname)" == "Darwin" ]; then
      ${macos}
    elif [ "$(uname)" == "Linux" ]; then
      ${nixos}
    fi
  "
''
