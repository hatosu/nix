{
  pkgs,
  lib,
  ...
}: {

  # fetch fonts
  fonts.packages = with pkgs; [
    gohufont
    hack-font
    noto-fonts
    source-code-pro
    font-awesome
  ]

  # enable all nerd-fonts
  ++ (lib.filter lib.isDerivation (lib.attrValues pkgs.nerd-fonts));

}
