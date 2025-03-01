{ pkgs, ... }: let x = pkgs; in { environment.systemPackages =

  # custom
  with x; [
    install
    help
    nixfind
    nvim
  ]

  # default
  ++ (with pkgs; [
    zip
    tokei
    tree
    lshw
  ])

  # fresh
  ++ (with pkgs.fresh; [
    zoom-us /*need for school*/
  ])

  # latest
  ++ (with pkgs.latest; [
    gdb /*op debugger*/
    git
    wget
    ffmpeg
    openssh
    ungoogled-chromium /*login browsing*/
    tor-browser /*non-login browsing*/
    matrix-commander-rs /*matrix for terminal*/
  ])

  # stable
  ++ (with pkgs.stable; [
    libreoffice /*slideshows, documents, spreadsheets, databases*/
    rnote /*mspaint*/
    anki-bin /*flashcards*/
    lmms /*music making*/
    synfigstudio /*character rigging, made this: https://www.youtube.com/watch?v=hWpnZuinhCA*/
    aseprite /*pixel art*/
    krita /*art*/
    kdenlive /*video editing*/
    freecad-wayland /*3d prints*/
    godot_4 /*make game without optimize min-max*/
    blender /*3d models/animations*/
  ])

  # pinned
  ++ (with pkgs.pinned; [
    video-trimmer
    element /*search elements of periodic table in terminal*/
  ]);

  # fonts
  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
    gohufont
    hack-font
    noto-fonts
  ] ++ (lib.filter lib.isDerivation (lib.attrValues pkgs.nerd-fonts));

}
