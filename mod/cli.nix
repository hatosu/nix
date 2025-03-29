{ pkgs, ... }: {

  # todo: do a let in that makes a custom package, that
  # targets a config file used by alacritty and just slap it here
  environment.systemPackages = [pkgs.alacritty];

  programs.zsh = {
    enable = true;
  };
   
}
