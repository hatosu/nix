{ pkgs, ... }: let x = pkgs; owner = "NixOS"; repo = "nixpkgs";
system = "x86_64-linux"; y = pkgs; in { environment.systemPackages =

  # custom
  with x; [
    hx
  ]

  # default
  ++ (with pkgs; [  
    zip
    tokei
    tree
    lshw
    skim
    bottom
    htop
    gping
    rmlint
    gimp
    ghc # ghci
    inetutils # ftp
  ])

  # latest
  ++ (with pkgs.latest; [
    gdb # op debugger
    git
    wget
    ffmpeg
    openssh
  ])

  # stable
  ++ (with pkgs.stable; [
    libreoffice # slideshows, documents, spreadsheets, databases
    rnote # mspaint
    anki-bin # flashcards
    lmms # music production
    synfigstudio # character rigging, made this: https://www.youtube.com/watch?v=hWpnZuinhCA
    aseprite # pixel art
    krita # art
    kdenlive # video editing
    freecad # 3d prints
    godot_4 # make game w/o optimize min-max
    blender # 3d models/animations
    inkscape # vector drawing
  ])

  # pinned
  ++ (with y; [

    (import (fetchFromGitHub {
      rev = "46fbd894a87c6b9e64c22d8a4c462b90d1438dcb";
      sha256 = "sha256-U5R0VmNoAZz8N+xyTDteXT8yaZYUG4mKc61cGMNGwiA=";
      inherit owner repo;
    }){inherit system;}).cowsay

  ]);

}
