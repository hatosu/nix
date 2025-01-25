{ pkgs, inputs, config, ... }: let

  /* notes:
    - sudo systemctl status minecraft-server-smp.service
    - tmux -S /run/minecraft/smp.sock attach 
  */

  dataDir = "/var/lib/minecraft";

  runDir = "/run/minecraft";

  serverFlags = builtins.concatStringsSep '' '' [
    "-XX:+UnlockExperimentalVMOptions"
    "-XX:+UnlockDiagnosticVMOptions"
    "-XX:+AlwaysActAsServerClassMachine"
    "-XX:+AlwaysPreTouch"
    "-XX:+DisableExplicitGC"
    "-XX:NmethodSweepActivity=1"
    "-XX:ReservedCodeCacheSize=400M"
    "-XX:NonNMethodCodeHeapSize=12M"
    "-XX:ProfiledCodeHeapSize=194M"
    "-XX:NonProfiledCodeHeapSize=194M"
    "-XX:-DontCompileHugeMethods"
    "-XX:MaxNodeLimit=240000"
    "-XX:NodeLimitFudgeFactor=8000"
    "-XX:+UseVectorCmov"
    "-XX:+PerfDisableSharedMem"
    "-XX:+UseFastUnorderedTimeStamps"
    "-XX:+UseCriticalJavaThreadPriority"
    "-XX:ThreadPriorityPolicy=1"
  ];

  serverProperties = {
    level-name = "world";
    motd = "Some description of the server idk think of one...";
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
    online-mode = true;
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
    white-list = false;
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

  services.minecraft-servers = {

    inherit dataDir runDir;
    enable = true;
    eula = true;
    openFirewall = true;

    servers.smp = {
      inherit serverProperties;
      enable = true;
      # package pkgs.fabricServers.fabric-1_18_2.override { loaderVersion = "0.14.20"; };
      package = pkgs.papermcServers.papermc-1_21_4;
      autoStart = true;
      enableReload = true;
      extraReload = ''
        echo 'reloading server' > /run/minecraft/proxy.stdin
        mcrun alert "buh..."
        rm -rf /var/lib/_backup
        mkdir /var/lib/_backup
        cp -rf ${dataDir}/worlds* /var/lib/_backup
      '';
      jvmOpts = "${serverFlags}";
      operators.Hatosy = "7b93025c-8649-4912-9d8a-4f4067cd1140";
      symlinks = {

        "plugins" = pkgs.linkFarmFromDrvs "plugins" ( builtins.attrValues {
          Sleeper = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/Kt3eUOUy/versions/AJnc8xNL/Sleeper-1.6.2.jar";
            sha256 = "0x8cjrhvv63dbfhznip7ih2zsknwi5vb65742zws9qiw1r6jczxz";
          };
          Geyser = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/2JSXI43V/Geyser-Spigot.jar";
            hash = "sha256-GhOHf0r9j/LEnMObKI58d/E2ItYwovlAnK22Q3ObSDc=";
          };
          HuskHomes = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/J6U9o3JG/versions/pN4VzRBd/HuskHomes-Paper-4.9.jar";
            hash = "sha256-KZhyopsdvHaTjDo23X4UflBvW9PWRxPYqk2MKRlewzI=";
          };
          HoloMobHealth = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/UitDglMl/versions/5E5pcBud/HoloMobHealth-2.3.12.0.jar";
            hash = "sha256-TYMPhZxCJhl9VLQM5EnM1yGgpT8JBc5Yj5Alr617Vi0=";
          };
          ImageFrame = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/lJFOpcEj/versions/mB9pIXP1/ImageFrame-1.7.14.0.jar";
            hash = "sha256-Q+Ptr7PLrDj45a9sC3FDVW0sUuQNZQuiJxjwNjrO8n4=";
          };
          CrazyAuctions = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/U3Q9GAst/versions/OU6J79i3/CrazyAuctions-1.7.0.jar";
            hash = "sha256-VA/p6kaPZAEh4oglTGAq6xdxbG1f9e06SyQs+zJacVc=";
          };
          InvSee = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/bYazc7fd/versions/5iErH7nw/InvSee%2B%2B.jar";
            hash = "sha256-mjLh/fmWB9pylxuuu4ZtJYiPu7A0STMSuJb6obvqbUU=";
          };
          Spawn = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/Pw3KRjwE/versions/mgrZ4A8t/Spawn-2.4.1.jar";
            hash = "sha256-m5xNFQ0ND3QaOSUg45t3Akblj7sfUbzxyOkPETFh6b4=";
          };
          ajLeaderboards = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/C9BKEl8Y/versions/vnRMWhm2/ajLeaderboards-2.9.0.jar";
            hash = "sha256-M5uhK5N8i2OGayR/plC0Ij2L4ZJngTz5+IPlbNO34/0=";
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
    };
  };
}
