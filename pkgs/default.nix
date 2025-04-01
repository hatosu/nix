pkgs: {

  # main
  astal = pkgs.callPackage ./astal {};
  hx = pkgs.callPackage ./hx {};
  nyxt = pkgs.callPackage ./nyxt {};
  chrome = pkgs.callPackage ./chrome {};

  # util
  install = pkgs.callPackage ./install {};
  wallpaper = pkgs.callPackage ./wallpaper {};
  wlocr = pkgs.callPackage ./wlocr {};

}
