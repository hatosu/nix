{ pkgs, ... }: {

  services.ollama = {
    enable = true;
    package = pkgs.latest.ollama;
    acceleration = "cuda";
    loadModels = [ "deepseek-r1:1.5b" ];
  };

}
