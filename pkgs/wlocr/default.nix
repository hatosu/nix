{
  writeShellScriptBin,
  lib,
  grim,
  libnotify,
  slurp,
  tesseract5,
  wl-clipboard,
  langs ? "eng+fra+jpn+jpn_vert+kor+kor_vert+spa",
}: let
  _ = lib.getExe;
in
  writeShellScriptBin "wlocr" ''
    ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} -l ${langs} - - | ${wl-clipboard}/bin/wl-copy
    echo "$(${wl-clipboard}/bin/wl-paste)"
    ${_ libnotify} -- "$(${wl-clipboard}/bin/wl-paste)"
  ''
