let
  importJSON = file: builtins.fromJSON (builtins.readFile file);
  flakeLock = importJSON ./flake.lock;
  loadInput = { locked, ... }:
    assert locked.type == "github";
    builtins.fetchTarball {
      url = "https://github.com/${locked.owner}/${locked.repo}/archive/${locked.rev}.tar.gz";
      sha256 = locked.narHash;
    };
  nixpkgs = loadInput flakeLock.nodes.nixpkgs;
in
import nixpkgs {
  config = { };
  overlays = [ ];
}
