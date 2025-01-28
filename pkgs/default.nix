pkgs: {

  # utils
  nixfind = pkgs.callPackage ./nixfind {};
  nixpaper = pkgs.callPackage ./nixpaper {};
  nixocr = pkgs.callPackage ./nixocr {};
  help = pkgs.callPackage ./help {};
  install = pkgs.callPackage ./install {};
  yaml2nix = pkgs.callPackage ./yaml2nix {};

  # games
  wiiudownloader = pkgs.callPackage ./wiiudownloader {};

}
