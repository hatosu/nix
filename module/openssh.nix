{ pkgs, strings, ... }: {

  services.openssh = {

    enable = true;
    package = pkgs.openssh;
    startWhenNeeded = false;
    banner = strings.asciitxt;

    # extraConfig = ''
    #   StreamLocalBindUnlink yes
    # '';

    ports = [ 22 ];
    openFirewall = true;

    #authorizedKeysInHomedir = true;
    #authorizedKeysCommandUser = "nobody";
    #authorizedKeysFiles = [ ];
    #authorizedKeysCommand = "";

    #allowSFTP = true;
    #sftpServerExecutable = "";
    #sftpFlags = [ ];

    #listenAddresses.*.port
    #listenAddresses.*.addr
    #listenAddresses

    #knownHosts.<name>.publicKeyFile
    #knownHosts.<name>.publicKey
    #knownHosts.<name>.hostNames
    #knownHosts.<name>.extraHostNames
    #knownHosts.<name>.certAuthority

    # hostKeys = [
    #   {
    #     bits = 4096;
    #     path = "/etc/ssh/ssh_host_rsa_key";
    #     type = "rsa";
    # 
    #   }
    #   {
    #     path = "/etc/ssh/ssh_host_ed25519_key";
    #     type = "ed25519";
    #   }
    # ];

    #moduliFile = "${pkgs.openssh}/etc/ssh/moduli";

    settings = {

      # use only key auth
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;

      # allowed/denied users/groups
      AllowUsers = [ "hatosu" ];
      #AllowGroups = [ "wheel" ];
      #DenyUsers = [ "" ];
      #DenyGroups = [ "root" ];

      X11Forwarding = false;
      UsePAM = true;
      UseDns = true;
      StrictModes = true;
      PrintMotd = false;

      LogLevel = "INFO";
      AuthorizedPrincipalsFile = "none";

      PermitRootLogin = "no";
      GatewayPorts = "no";

      # Macs = [
      #   "hmac-sha2-512-etm@openssh.com"
      #   "hmac-sha2-256-etm@openssh.com"
      #   "umac-128-etm@openssh.com"
      # ];
      #
      # Ciphers = [
      #   "chacha20-poly1305@openssh.com"
      #   "aes256-gcm@openssh.com"
      #   "aes128-gcm@openssh.com"
      #   "aes256-ctr"
      #   "aes192-ctr"
      #   "aes128-ctr"
      # ];
      #
      # KexAlgorithms = [
      #   "sntrup761x25519-sha512@openssh.com"
      #   "curve25519-sha256"
      #   "curve25519-sha256@libssh.org"
      #   "diffie-hellman-group-exchange-sha256"
      # ];

    };
  };

  services.fail2ban = {
    enable = true;
    package = pkgs.fail2ban;

    # ban ip after 3 fails
    maxretry = 3;

    # length of ban
    bantime = "24h";

    # whitelist
    ignoreIP = [
      #"10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16"
      #"142.250.189.206"
      #"nixos.wiki"
    ];

    # max ban time, formula based on offense count, and multipliers
    bantime-increment = {
      enable = true;
      maxtime = "8760h";
      #formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      multipliers = "1 2 4 8 16 32 64";
      overalljails = true;
    };

    jails = {

      # apache-nohome-iptables.settings = {
      #   # Block an IP address if it accesses a non-existent
      #   # home directory more than 5 times in 10 minutes,
      #   # since that indicates that it's scanning.
      #   filter = "apache-nohome";
      #   action = ''iptables-multiport[name=HTTP, port="http,https"]'';
      #   logpath = "/var/log/httpd/error_log*";
      #   backend = "auto";
      #   findtime = 600;
      #   bantime  = 600;
      #   maxretry = 5;
      # };

      # ngnix-url-probe.settings = { 
      #   enabled = true;
      #   filter = "nginx-url-probe";
      #   logpath = "/var/log/nginx/access.log";
      #   action = ''%(action_)s[blocktype=DROP]
      #            ntfy'';
      #   backend = "auto"; # Do not forget to specify this if your jail uses a log file
      #   maxretry = 5; 
      #   findtime = 600;
      # }; 

    };

  };

  environment.etc = {

    # # Define an action that will trigger a Ntfy push notification upon the issue of every new ban
    # "fail2ban/action.d/ntfy.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
    #   [Definition]
    #   norestored = true # Needed to avoid receiving a new notification after every restart
    #   actionban = curl -H "Title: <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(hostname) after <failures> attempts of hacking the system." https://ntfy.sh/Fail2banNotifications
    # '');
    #
    # # Defines a filter that detects URL probing by reading the Nginx access log
    # "fail2ban/filter.d/nginx-url-probe.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
    #   [Definition]
    #   failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
    # '');

  };
}
