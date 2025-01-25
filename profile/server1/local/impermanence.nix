{
  pkgs,
  lib,
  config,
  ...
}: {

  programs.fuse.userAllowOther = true;

  fileSystems."/persist".neededForBoot = true;

  fileSystems."/".neededForBoot = true;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi
    delete_subvolume_recursively() {
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      btrfs subvolume delete "$1"
    }
    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
    done
    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  environment.persistence."/persist/system" = {
    hideMounts = true;

    # root
    directories = [
      "/var/lib/minecraft"
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      {directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o=";}
    ];
    files = [
      {file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; };}
    ];

    # home
    users.server1 = {
      directories = [
        ".cache/dconf" 
        ".config/dconf"
      ];
    };
  
  };

  systemd.tmpfiles.settings = { 
    "persist-server1-homedir" = {
      "/persist/home/server1" = {
        d = {
          group = "users";
          user = "server1";
          mode = "0700";
        };
      };
    };
  };

  system.activationScripts.chown.text = ''
    chown -R server1:users /persist/system/home/server1
    chown -R server1:users /home/server1
  '';

  # declare machine-id (prevents impermanence errors)
  environment.etc.machine-id.text = "98y98gnskjdiqfalfnfajkngf99384az";

  # satisfy hm with dconf
  home-manager.users.server1.home.packages = [pkgs.dconf];

  # move xdg folders to .cache
  home-manager.users.server1.xdg = let
    home = config.home-manager.users.server1.home.homeDirectory;
  in {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      download = "${home}/.cache/Downloads";
      desktop = "${home}/.cache/Desktop";
      videos = "${home}/.cache/Videos";
      pictures = "${home}/.cache/Pictures";
      documents = "${home}/.cache/Documents";
      templates = "${home}/.cache/Templates";
      publicShare = "${home}/.cache/Public";
      music = "${home}/.cache/Music";
    };
  };

}
