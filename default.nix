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
  mkGzip = name: drv:
    pkgs.runCommand
      "${name}-${system}.gz"
      { nativeBuildInputs = [ pkgs.gzip ]; }
      "gzip --no-name --stdout ${drv}/bin/${name} > $out";
in
{
  inherit bash;
  archive = mkGzip "bash" bash;
  bin = mkBin "bash" bash;
}
