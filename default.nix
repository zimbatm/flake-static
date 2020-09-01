{ pkgs ? import ./nixpkgs.nix }:
let
  system = pkgs.system;

  # Extract the main binary of the package and copy it to the root
  mkBin = name: drv:
    pkgs.runCommand
      "${name}-${system}"
      { }
      "cp ${drv}/bin/${name} $out";

  # Creates a reproducible archive
  mkBinGzip = name: drv:
    pkgs.runCommand
      "${name}-${system}.gz"
      { nativeBuildInputs = [ pkgs.gzip ]; }
      "gzip --no-name --stdout ${drv}/bin/${name} > $out";

  bash =
    let
      orig =
        if pkgs.stdenv.isDarwin then
        # musl is not available on darwin
          pkgs.bashInteractive
        else
          pkgs.pkgsStatic.bashInteractive;
    in
    orig.overrideAttrs
      (attrs: {
        postFixup = ''
          rm -rf "$out/bin/sh" "$out/share" "$out/bin/bashbug"
        '';
      });

  coreutils =
    let
      orig =
        if pkgs.stdenv.isDarwin then
        # musl is not available on darwin
          pkgs.coreutils
        else
          pkgs.pkgsStatic.coreutils;
    in
    orig.overrideAttrs
      (attrs: {
        postFixup = ''
          rm -rf "$out/nix-support"
        '';
      });
in
{
  # inherit bash;
  bash-bin = mkBin "bash" bash;
  bash-bin-gzip = mkBinGzip "bash" bash;

  # inherit coreutils;
  coreutils-bin = mkBin "coreutils" coreutils;
  coreutils-bin-gzip = mkBinGzip "coreutils" coreutils;
}
