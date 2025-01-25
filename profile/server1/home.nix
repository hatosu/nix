{ nixosVersion, ... }: {

  # reload ALL system units when changing configs
  systemd.user.startServices = "sd-switch";

  # hm
  programs.home-manager.enable = true;
  home.username = "server1";
  home.homeDirectory = "/home/server1";

  # version
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = nixosVersion;

}
