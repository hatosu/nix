{
  ...
}: {

  # idk just enable this
  security.rtkit.enable = true;

  # disable pulseaudio
  services.pulseaudio.enable = false;

  # pipewire :D
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = {
            main."monitor.libcamera" = "disabled";
          };
        };
      };
    };
  };

}
