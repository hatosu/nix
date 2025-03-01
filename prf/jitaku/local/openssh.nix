{ pkgs, strings, ... }: let

  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIURvYLzxzaWxTRTOg52dVu/19VReYNr/v8xGw0eEeGZ ssh for server1 on nixos"
  ];

  portInt = 44433;

  portStr = "44433";

in {

  services.openssh = {

    enable = true;
    package = pkgs.openssh;
    startWhenNeeded = false;
    banner = strings.asciitxt;

    ports = [portInt];
    openFirewall = true;

    moduliFile = "${pkgs.openssh}/etc/ssh/moduli";

    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    settings = {

      # use only key auth
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;

      X11Forwarding = false;
      UsePAM = true;
      UseDns = true;
      StrictModes = true;
      PrintMotd = false;
      LogLevel = "INFO";
      AuthorizedPrincipalsFile = "none";
      PermitRootLogin = "no";
      GatewayPorts = "no";

      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];

      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];

      KexAlgorithms = [
        "sntrup761x25519-sha512@openssh.com"
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group-exchange-sha256"
      ];

    };
  };

  services.fail2ban = {

    enable = true;
    package = pkgs.fail2ban;

    # ban ip after 3 fails
    maxretry = 3;

    # length of ban
    bantime = "24h";

    # whitelist ips
    ignoreIP = [
      "192.168.1.244"
      "nixos.wiki"
    ];

    # max ban time, formula based on offense count, and multipliers
    bantime-increment = {
      enable = true;
      maxtime = "8760h";
      multipliers = "1 2 4 8 16 32 64";
      overalljails = true;
    };

  };

  users.users = {
    hatosu.openssh.authorizedKeys.keys = keys;
  };

  environment.interactiveShellInit = ''
    t98hjvkwt4s84(){
      printf "ip: " >&2
      read -r _IP
      printf "src: " >&2
      read -r _SRC
      printf "dst: " >&2
      read -r _DST
    }
    server1_to_client(){
      t98hjvkwt4s84
      sh -c "scp -i ~/.ssh/server1 -P ${portStr} -r hatosu@$_IP:$_SRC $_DST"
    }
    client_to_server1(){
      t98hjvkwt4s84
      sh -c "scp -i ~/.ssh/server1 -P ${portStr} -r $_SRC hatosu@$_IP:$_DST"
    }
  '';

}
