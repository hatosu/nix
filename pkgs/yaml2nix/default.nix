{ pkgs ? import <nixpkgs> {} }: let 
  name = "yaml2nix";
  zip = pkgs.fetchurl {
    url = "https://files.catbox.moe/8aaa5z.zip";
    sha256 = "12namsh453vdaahrbxrqjs8578s3b41p1b85vjqcf9dbxdk1h62h";
  };
in pkgs.stdenv.mkDerivation {
  name = "${name}";
  src = zip;
  buildInputs = pkgs.unzip;
  phases = [
    "buildPhase"
    "installPhase"
  ];
  buildPhase = ''
    unzip ${zip}
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin
  '';
}
