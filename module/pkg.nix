{ pkgs, ... }: { environment.systemPackages =

  # default
  with pkgs; [
    install
    #yaml2nix
    help
    nixfind
    zip
    wget
    lshw
    openssh
  ]

  # fresh
  ++ (with pkgs.fresh; [
    git
  ])

  # latest
  ++ (with pkgs.latest; [
    ffmpeg
  ])

  # stable
  ++ (with pkgs.stable; [
    tree
  ])

  # pinned
  ++ (with pkgs.pinned; [
    element
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
