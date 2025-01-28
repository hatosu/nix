{ inputs, pkgs, ... }: let

  /* NOTE:
    if the server doesnt start and has
    missing files, literally just spam
    rebuild and reboot until it works
  */

  level-name = ''Re: Japanese Academy SMP'';

  motd = ''taking a \u00a7d\u00a7ocozy study break \u00a7rfrom \u00a7c\u00a7nthe academy. . . \u00a7d\u26cf'';

  icon = pkgs.fetchurl {
    name = "server-icon.png";
    url = "https://picsur.org/i/f0515567-961a-4965-b700-88c0b931799f.png";
    sha256 = "1waqfs1z89lm0m55hqn8b6pv157jjia2sw58155q1y82v1yaa4jy";
  };

  opts = builtins.concatStringsSep '' '' [
    "-Xmx18G"
    "-Xms18G"
    "-XX:+AlwaysPreTouch"
    "-XX:+DisableExplicitGC"
    "-XX:+ParallelRefProcEnabled"
    "-XX:+PerfDisableSharedMem"
    "-XX:+UnlockExperimentalVMOptions"
    "-XX:+UseG1GC"
    "-XX:G1HeapRegionSize=16M"
    "-XX:G1HeapWastePercent=5"
    "-XX:G1MaxNewSizePercent=50"
    "-XX:G1MixedGCCountTarget=4"
    "-XX:G1MixedGCLiveThresholdPercent=90"
    "-XX:G1NewSizePercent=40"
    "-XX:G1RSetUpdatingPauseTimePercent=5"
    "-XX:G1ReservePercent=15"
    "-XX:InitiatingHeapOccupancyPercent=20"
    "-XX:MaxGCPauseMillis=200"
    "-XX:MaxTenuringThreshold=1"
    "-XX:SurvivorRatio=32"
    "-Dusing.aikars.flags=https://mcflags.emc.gs"
    "-Daikars.new.flags=true"
    "-Djava.net.preferIPv4Stack=true"
    "-Djava.net.preferIPv6Addresses=false"
  ];

in {

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  networking.firewall.allowedTCPPorts = [ 25565 19132 ];

  systemd.tmpfiles.rules = [
    "d /srv 0777 minecraft minecraft"
    "d /srv/minecraft 0777 minecraft minecraft"
    "d /persist/system/srv 0777 minecraft minecraft"
    "d /persist/system/srv/minecraft 0777 minecraft minecraft"
  ];

  system.activationScripts.chmod.text = ''
    chown -R minecraft:minecraft /srv
    chown -R minecraft:minecraft /srv/minecraft
    chown -R minecraft:minecraft /persist/system/srv
    chown -R minecraft:minecraft /persist/system/srv/minecraft
  '';

  system.activationScripts.backup.text = ''
    if [ -d "/srv/minecraft/default/world" ]
    then
      mkdir -p /srv/world_backup
      rm -rf /srv/world_backup/*
      cp -rf /srv/minecraft/default/world* /srv/world_backup
    else
      printf "\nno current worlds to backup...\n"
    fi
  '';

  services.minecraft-servers = {

    enable = true;
    eula = true;
    dataDir = "/srv/minecraft";
    runDir = "/run/minecraft";

    servers.default = {

      enable = true;
      openFirewall = true;
      autoStart = true;
      restart = "always";
      enableReload = false;
      jvmOpts = "${opts}";
      files."server-icon.png" = icon;

      package = pkgs.paperServers.paper-1_21_4.override {
        jre = pkgs.graalvm-ce;
      };

      serverProperties = {
        enable-rcon = false;
        enforce-whitelist = true;
        white-list = true;
        server-port = 25565;
        simulation-distance = 8;
        view-distance = 32;
        network-compression-threshold = 64;
        gamemode = "survival";
        difficulty = "easy";
        inherit level-name motd;
      };

      symlinks = {

        "config/paper-world-defaults.yml" = let yml = pkgs.writeText "-" ''
          anticheat:
            anti-xray:
              enabled: true
              engine-mode: 2
              hidden-blocks:
              - air
              - copper_ore
              - deepslate_copper_ore
              - raw_copper_block
              - diamond_ore
              - deepslate_diamond_ore
              - gold_ore
              - deepslate_gold_ore
              - iron_ore
              - deepslate_iron_ore
              - raw_iron_block
              - lapis_ore
              - deepslate_lapis_ore
              - redstone_ore
              - deepslate_redstone_ore
              lava-obscures: false
              max-block-height: 64
              replacement-blocks:
              - chest
              - amethyst_block
              - andesite
              - budding_amethyst
              - calcite
              - coal_ore
              - deepslate_coal_ore
              - deepslate
              - diorite
              - dirt
              - emerald_ore
              - deepslate_emerald_ore
              - granite
              - gravel
              - oak_planks
              - smooth_basalt
              - stone
              - tuff
              update-radius: 2
              use-permission: false
        ''; in yml;

        "world_nether/paper-world.yml" = let yml = pkgs.writeText "-" ''
           anticheat:
             anti-xray:
               enabled: true
               engine-mode: 2
               hidden-blocks:
               - air
               - ancient_debris
               - bone_block
               - glowstone
               - magma_block
               - nether_bricks
               - nether_gold_ore
               - nether_quartz_ore
               - polished_blackstone_bricks
               lava-obscures: false
               max-block-height: 128
               replacement-blocks:
               - basalt
               - blackstone
               - gravel
               - netherrack
               - soul_sand
               - soul_soil
               update-radius: 2
               use-permission: false
        ''; in yml;

         "plugins" = pkgs.linkFarmFromDrvs "plugins" ( builtins.attrValues {
           Geyser = pkgs.fetchurl {
             url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/T7F2YvxM/Geyser-Spigot.jar";
             sha256 = "0axsmh328hi10v799g5k9cs66x5byklgwvw5sp7pvywmbfqzjqfz";
           };
           Sleeper = pkgs.fetchurl {
             url = "https://cdn.modrinth.com/data/Kt3eUOUy/versions/AJnc8xNL/Sleeper-1.6.2.jar";
             sha256 = "0x8cjrhvv63dbfhznip7ih2zsknwi5vb65742zws9qiw1r6jczxz";
           };
           InvSee = pkgs.fetchurl {
             url = "https://cdn.modrinth.com/data/bYazc7fd/versions/5iErH7nw/InvSee%2B%2B.jar";
             hash = "sha256-mjLh/fmWB9pylxuuu4ZtJYiPu7A0STMSuJb6obvqbUU=";
           };
           Statusbot = pkgs.fetchurl {
             url = "https://cdn.modrinth.com/data/G9ZpI0bU/versions/HnD8Ln4X/Statusbot-18.2-Spigot.jar";
             hash = "sha256-WQb3jUIZtCn7Nc58b4zc6vF8pqgQCQwAYG0SWeJVzeI=";
           };
           CopperItems = pkgs.fetchurl {
             url = "https://cdn.modrinth.com/data/52uRwnTq/versions/KeoAFokD/CopperItems-2.1.jar";
             hash = "sha256-jdNZkNns+oOsB2jliiLzB6SRuzykgPMPRx17UT/MmYU=";
           };
         });

      };

    };
  };
}
