pkgs: {

  install = pkgs.callPackage ./install {};
  nvim = pkgs.callPackage ./nvim {};
  hx = pkgs.callPackage ./hx {};
  wallpaper = pkgs.callPackage ./wallpaper {};
  nixfind = pkgs.callPackage ./nixfind {};
  help = pkgs.callPackage ./help {};
  wlocr = pkgs.callPackage ./wlocr {};
  obsidian = pkgs.callPackage ./obsidian {};
  wiiudownloader = pkgs.callPackage ./wiiudownloader {};

}
