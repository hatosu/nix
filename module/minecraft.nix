{ pkgs, inputs, ... }: let

  /* notes:
    - sudo systemctl status minecraft-server-smp.service
    - tmux -S /run/minecraft/smp.sock attach 
  */

  dataDir = "/srv/minecraft";

  backupDir = "/srv/_backup";

  serverFlags = builtins.concatStringsSep '' '' [
    "-Xms2G"
    "-Xmx6G"
    "-XX:+UseG1GC"
    "-XX:+ParallelRefProcEnabled"
    "-XX:MaxGCPauseMillis=200"
    "-XX:+UnlockExperimentalVMOptions"
    "-XX:+DisableExplicitGC"
    "-XX:+AlwaysPreTouch"
    "-XX:G1NewSizePercent=30"
    "-XX:G1MaxNewSizePercent=40"
    "-XX:G1HeapRegionSize=8M"
    "-XX:G1ReservePercent=20"
    "-XX:G1HeapWastePercent=5"
    "-XX:G1MixedGCCountTarget=4"
    "-XX:InitiatingHeapOccupancyPercent=15"
    "-XX:G1MixedGCLiveThresholdPercent=90"
    "-XX:SurvivorRatio=32"
    "-XX:+PerfDisableSharedMem"
    "-XX:MaxTenuringThreshold=1"
  ];

  serverProperties = {

    level-name = "日本語アカデミーSMP";
    motd = "weeb riddled overworld municipality...";
    gamemode = "survival";
    difficulty = "hard";
    initial-enabled-packs = "vanilla";

    server-port = 25565;
    max-chained-neighbor-updates = 1000000;
    network-compression-threshold = 256;
    max-tick-time = 60000;
    max-players = 50;
    view-distance = 12;
    op-permission-level = 4;
    entity-broadcast-range-percentage = 100;
    simulation-distance = 12;
    player-idle-timeout = 0;
    rate-limit = 0;
    function-permission-level = 2;
    spawn-protection = 0;
    max-world-size = 29999984;

    enable-jmx-monitoring = false;
    enable-command-block = false;
    enable-query = false;
    enforce-secure-profile = true;
    pvp = true;
    generate-structures = true;
    require-resource-pack = false;
    use-native-transport = true;
    online-mode = false; # accept cracked players
    enable-status = true;
    allow-flight = false;
    broadcast-rcon-to-ops = true;
    allow-nether = true;
    enable-rcon = false;
    sync-chunk-writes = true;
    prevent-proxy-connections = false;
    hide-online-players = false;
    force-gamemode = true;
    hardcore = false;
    white-list = true;
    broadcast-console-to-ops = true;
    spawn-npcs = true;
    spawn-animals = true;
    log-ips = true;
    spawn-monsters = true;
    enforce-whitelist = false;

  };

in {

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 19132 ];
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0777 minecraft minecraft"
    "d ${backupDir} 0777 minecraft minecraft"
  ];

  users = {
    users.minecraft = {
      shell = pkgs.bash;
      isSystemUser = true;
      group = "minecraft";
      extraGroups = ["wheel" "minecraft"];
      home = "${dataDir}";
    };
    groups.minecraft = {};
  };

  services.minecraft-servers = {

    inherit dataDir;
    enable = true;
    eula = true;
    openFirewall = true;

    managementSystem = {
      tmux = {
        enable = true;
        socketPath = name: "${dataDir}/sessions/${name}.sock";
      };
    };

    servers.smp = {

      inherit serverProperties;
      enable = true;
      # package pkgs.fabricServers.fabric-1_18_2.override { loaderVersion = "0.14.20"; };
      package = pkgs.papermcServers.papermc-1_21_4;
      autoStart = true;
      enableReload = true;
      jvmOpts = "${serverFlags}";

      extraReload = ''
        echo 'reloading server' > /run/minecraft/proxy.stdin
        mcrun alert "buh..."
        rm -rf ${backupDir}/*
        cp -rf ${dataDir}/worlds* ${backupDir}
      '';

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

        "plugins/Geyser-Spigot/config.yml" = let yml = pkgs.writeText "-" ''
          bedrock:
            port: 19132
        ''; in yml;

        # "plugins/Statusbot/statusbot_config.yml" = let yml = pkgs.writeText "-" ''
        # ''; in yml;

        "plugins/Chunky/config.yml" = let yml = pkgs.writeText "-" ''
           version: 2
           language: en
           continue-on-restart: false
           force-load-existing-chunks: false
           silent: false
           update-interval: 1
        ''; in yml;

        "plugins/HuskHomes/config.yml" = let yml = pkgs.writeText "-" ''
           language: en-gb
           check_for_updates: false
           database:
             type: SQLITE
             pool_options:
               size: 12
               idle: 12
               lifetime: 1800000
               keep_alive: 30000
               timeout: 20000
             table_names:
               PLAYER_DATA: huskhomes_users
               PLAYER_COOLDOWNS_DATA: huskhomes_user_cooldowns
               POSITION_DATA: huskhomes_position_data
               SAVED_POSITION_DATA: huskhomes_saved_positions
               HOME_DATA: huskhomes_homes
               WARP_DATA: huskhomes_warps
               TELEPORT_DATA: huskhomes_teleports
           general:
             max_homes: 1
             max_public_homes: 1
             stack_permission_limits: false
             permission_restrict_warps: false
             teleport_warmup_time: 5
             teleport_warmup_cancel_on_damage: true
             teleport_warmup_cancel_on_move: true
             teleport_warmup_display: ACTION_BAR
             teleport_invulnerability_time: 0
             teleport_request_expiry_time: 60
             strict_tpa_here_requests: true
             list_items_per_page: 12
             always_respawn_at_spawn: false
             teleport_async: true
             names:
               overwrite_existing: true
               case_insensitive: true
               restrict: false
               regex: '[a-zA-Z0-9-_]*'
             descriptions:
               restrict: false
               regex: \A\p{ASCII}*\z
             back_command:
               return_by_death: false
               save_on_teleport_event: false
             sound_effects:
               enabled: true
               types:
                 TELEPORTATION_COMPLETE: entity.enderman.teleport
                 TELEPORTATION_WARMUP: block.note_block.banjo
                 TELEPORTATION_CANCELLED: entity.item.break
                 TELEPORT_REQUEST_RECEIVED: entity.experience_orb.pickup
           cross_server:
             enabled: false
             cluster_id: main
             broker_type: PLUGIN_MESSAGE
             global_spawn:
               enabled: false
               warp_name: Spawn
             global_respawning: false
           rtp:
             region:
               min: 1
               max: 2
             distribution_mean: 0.75
             distribution_standard_deviation: 2.0
             restricted_worlds:
               - world
               - world_nether
               - world_the_end
           cooldowns:
             enabled: true
             cooldown_times:
               RANDOM_TELEPORT: 999
           economy:
             enabled: false
             economy_costs:
               ADDITIONAL_HOME_SLOT: 9999.0
               MAKE_HOME_PUBLIC: 9999.0
               RANDOM_TELEPORT: 9999.0
             free_home_slots: 1
           map_hook:
             enabled: true
             show_public_homes: true
             show_warps: true
           disabled_commands: ['/rtp', '/warp', '/tp', '/back']
        ''; in yml;

        "plugins/CopperItems/config.yml" = let yml = pkgs.writeText "-" ''
           language: en_US
           enable-resource-pack: true
           items:
             axe:
               enable: true
               attack-damage: 3
               attack-speed: 0.1
             hoe:
               enable: true
             pickaxe:
               enable: true
             shovel:
               enable: true
             sword:
               enable: true
               attack-damage: 1
               attack-speed: 1
           armor:
             helmet:
               enable: true
               armor: 1
             chestplate:
               enable: true
               armor: 3
             leggings:
               enable: true
               armor: 2
             boots:
               enable: true
               armor: 1
        ''; in yml;

        "plugins" = pkgs.linkFarmFromDrvs "plugins" ( builtins.attrValues {
          Geyser = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/2JSXI43V/Geyser-Spigot.jar";
            hash = "sha256-GhOHf0r9j/LEnMObKI58d/E2ItYwovlAnK22Q3ObSDc=";
          };
          Sleeper = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/Kt3eUOUy/versions/AJnc8xNL/Sleeper-1.6.2.jar";
            sha256 = "0x8cjrhvv63dbfhznip7ih2zsknwi5vb65742zws9qiw1r6jczxz";
          };
          HuskHomes = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/J6U9o3JG/versions/pN4VzRBd/HuskHomes-Paper-4.9.jar";
            hash = "sha256-KZhyopsdvHaTjDo23X4UflBvW9PWRxPYqk2MKRlewzI=";
          };
          ImageFrame = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/lJFOpcEj/versions/mB9pIXP1/ImageFrame-1.7.14.0.jar";
            hash = "sha256-Q+Ptr7PLrDj45a9sC3FDVW0sUuQNZQuiJxjwNjrO8n4=";
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
          Chunky-Bukkit = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/fALzjamp/versions/ytBhnGfO/Chunky-Bukkit-1.4.28.jar";
            hash = "sha256-G6MwUA+JUDJRkbpwvOC4PnR0k+XuCvcIJnDDXFF3oy4=";
          };
        });

        /*THESE MODS WILL ONLY WORK WITH FABRIC -hatosu*/
        # "mods" = pkgs.linkFarmFromDrvs "mods" ( builtins.attrValues {
        #   Fabric-API = pkgs.fetchurl {
        #     url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/oGwyXeEI/fabric-api-0.102.0%2B1.21.jar";
        #     sha512 = "11732c4e36c3909360a24aa42a44da89048706cf10aaafa0404d7153cbc7395ff68a130f7b497828d6932740e004416b692650c3fbcc1f32babd7cb6eb9791d8";
        #   };
        # });

      };

      operators = {
        Hatosy = "7b93025c-8649-4912-9d8a-4f4067cd1140";
      };

      whitelist = {
        WintyzHeart = "b275f4e0-a6a1-4c54-9ac1-91680c91c3c9";
      };

    };
  };
}
