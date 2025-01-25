{ ... }: {

  networking.hostName = "server1";

  users.users.server1 = {
    isNormalUser = true;
    home = "/home/server1";
    initialPassword = ";";
    group = "users";
    extraGroups = ["wheel"];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  time.timeZone = "America/Los_Angeles";

}
