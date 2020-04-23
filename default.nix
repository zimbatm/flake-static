{ pkgs ? import ./nixpkgs.nix }:
let
  system = pkgs.system;

  bashOrig =
    if pkgs.stdenv.isDarwin then
      # musl is not available on darwin
      pkgs.bashInteractive
    else
      pkgs.pkgsStatic.bashInteractive;

  bash = bashOrig.overrideAttrs
    (attrs: {
      postFixup = ''
        rm -rf "$out/bin/sh" "$out/share" "$out/bin/bashbug"
      '';
    });

  mkBin = name: drv:
    pkgs.runCommand
      "${name}-${system}"
      { }
      "cp ${drv}/bin/${name} $out";

  # Creates a reproducible archive
  mkArchive = name: drv:
    pkgs.runCommand
      "${name}-${system}.tar.gz"
      { nativeBuildInputs = [ pkgs.gnutar ]; }
      "tar czvf $out --mode u+w -C ${drv} .";
in
{
  inherit bash;
  archive = mkArchive "bash" bash;
  bin = mkBin "bash" bash;
}
