{ pkgs ? import <nixpkgs> { } }:
rec {
  bash =
    let
      pkg =
        if pkgs.stdenv.isDarwin then
          pkgs.bashInteractive
        else
          pkgs.pkgsStatic.bashInteractive;
    in
    pkg.overrideAttrs
      (attrs: {
        postFixup = ''
          rm -rf "$out/bin/sh" "$out/share" "$out/bin/bashbug"
        '';
      });

  # Creates a reproducible archive
  archive = drv:
    pkgs.runCommand
      "${drv.name}.tar.gz"
      { nativeBuildInputs = [ pkgs.gnutar ]; }
      ''
        tar czvf $out --mode u+w -C ${drv} .
      '';

  bashTarball = archive bash;
}
