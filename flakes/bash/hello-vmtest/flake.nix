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
            # name = "${pname}-${version}"
            pname = "hello";
            version = "0.0.1";
            description = "description";

            src = ./.;

            unpackPhase = "true";

            buildPhase = 
            ''
              cat > hello <<EOF
              #! $SHELL
              echo "Hello Nixers!"
              EOF
              chmod +x hello
            '';

            installPhase =
              ''
                mkdir -p $out/bin
                cp hello $out/bin/
                chmod +x $out/bin/hello
              '';

            meta = { description = "An example application"; 
                     homepage = "https://example.com"; 
                     license = pkgs.lib.licenses.mit; 
                     mainProgram = "exampleApp"; 
                    };
          };
          default = hello;
        };

        checks = rec {

            # Additional tests, if applicable.
            test = pkgs.stdenv.mkDerivation {
              name = "hello-test";

              buildInputs = [ self.packages.${system}.hello ];

              unpackPhase = "true";

              buildPhase = ''
                echo 'running some integration tests'
                [[ $(hello) = 'Hello Nixers!' ]]
              '';

              installPhase = "mkdir -p $out";
            };
        };

        apps = rec {
          hello = flake-utils.lib.mkApp { drv = self.packages.${system}.hello; };
          default = hello;
        };


      }
    );
}
