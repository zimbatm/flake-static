{
  description = "A static bash distribution";
  edition = 201909;

  inputs.utils = {
    uri = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages = import ./. { inherit pkgs; };

        apps.bash = utils.lib.mkApp {
          drv = packages.bash;
          name = "bash";
        };

        defaultPackage = packages.bash;
        defaultApp = apps.bash;
      }
    );
}
