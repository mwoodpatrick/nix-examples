{
  # See https://github.com/mhwombat/nix-for-numbskulls/blob/main/flakes.md
  # for a brief overview of what each section in a flake should or can contain.

  description = "a very simple and friendly flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells = rec {
          default = pkgs.mkShell {
            packages = [ pkgs.cowsay ];
          };
        };

        packages = rec {
          hello = pkgs.stdenv.mkDerivation rec {
            name = "hello-flake";

            src = ./.;

            unpackPhase = "true";

            buildPhase = ":";

            installPhase =
              ''
                mkdir -p $out/bin
                cp $src/hello-flake $out/bin/hello-flake
                chmod +x $out/bin/hello-flake
              '';
          };
          default = hello;
        };

        apps = rec {
          hello = flake-utils.lib.mkApp { drv = self.packages.${system}.hello; };
          default = hello;
        };
      }
    );
}
