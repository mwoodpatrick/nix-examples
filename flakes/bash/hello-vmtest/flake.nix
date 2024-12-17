{
  # See https://github.com/mhwombat/nix-for-numbskulls/blob/main/flakes.md
  # for a brief overview of what each section in a flake should or can contain.
  # Based on [bash-hello](https://github.com/NixOS/templates/blob/master/bash-hello/flake.nix)
# [Practical Nix flake anatomy: a guided tour of flake.nix](https://vtimofeenko.com/posts/practical-nix-flake-anatomy-a-guided-tour-of-flake.nix)
# [Flakes - nixos.wiki](https://nixos.wiki/wiki/Flakes)
# [The nix flake user manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake.html)
# [The nix flake references manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake)
# [Official Nix templates](https://github.com/NixOS/templates)
# [View 0xmycf's full-sized avatar
# [0xmycf my-nix-flake-templates](https://github.com/0xmycf/my-nix-flake-templates.git)
# [flake-utils](https://github.com/numtide/flake-utils)
# [nix flake show [option...] flake-url](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-show) Show the output attributes provided by the patchelf flake:
# [nix flake init -t templates#bash-hello](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-init)
# git add flake.nix # required otherwise it will not build
# [nix build](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-build) build a derivation or fetch a store path
# [nix flake show](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-show) # show the outputs provided by a flake
# [nix flake check -v](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-check) # check whether the flake evaluates and run its tests
# [nix flake [--debug] metadata](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-metadata) # show flake metadata
# [nix develop](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-develop.html?form=MG0AV3) # needs devshell (not provided here) run a bash shell that provides the build environment of a derivation
# Note: this flake does not provide attribute 'devShells.x86_64-linux.default', 'devShell.x86_64-linux', 'packages.

  description = "a very simple and friendly flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
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

            meta = { 
                     description = "An example application"; 
                     mainProgram = "exampleApp"; 
                     homepage = "https://example.com"; 
                     license = lib.licenses.mit; 
                     platforms   =  lib.platforms.linux;
                     maintainers = with lib.maintainers; [ mwoodpatrick ];
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
        }

        // lib.optionalAttrs pkgs.stdenv.isLinux {
        # A VM test of the NixOS module.
        vmTest =
            with import (nixpkgs + "/nixos/lib/testing-python.nix") {
                inherit system;
              };

              makeTest {
                nodes = {
                  client = { ... }: {
                    imports = [ self.nixosModules.hello ];
                  };
                };

                testScript =
                  ''
                    start_all()
                    client.wait_for_unit("multi-user.target")
                    client.succeed("hello")
                  '';
              };
          };
      }
    );
}
