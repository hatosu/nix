{ ... }: let

  # mkpasswd -m sha-512
  INIT = "$6$SoGGa8Ucv6LWLfU9$ju1/qIllMy.JUxTv.rQvIYOrz9dZFoHi63o7An4CSy.V/DLgt5IorS3GtvFeZZTJAPsEu2aS.o2ImdRl3s8Bx0";

  # mkdir -p /var/keys/ && mkpasswd -m sha-512 > /var/keys/passwd
  SET = "/var/keys/passwd";

in {

  users.users.hatosu = {
    initialHashedPassword = INIT;
    hashedPasswordFile = SET;
    isNormalUser = true;
    home = "/home/hatosu";
    group = "users";
    extraGroups = [ "wheel" ];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  time.timeZone = "America/Los_Angeles";

}
