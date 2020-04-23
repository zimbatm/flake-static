let
  importJSON = file: builtins.fromJSON (builtins.readFile file);
  flakeLock = importJSON ./flake.lock;
  loadInput = { info, locked, ... }:
    assert locked.type == "github";
    builtins.fetchTarball {
      url = "https://github.com/${locked.owner}/${locked.repo}/archive/${locked.rev}.tar.gz";
      sha256 = info.narHash;
    };
  nixpkgs = loadInput flakeLock.inputs.nixpkgs;
in
import nixpkgs {
  config = { };
  overlays = [ ];
}
