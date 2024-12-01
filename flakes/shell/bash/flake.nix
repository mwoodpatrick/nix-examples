# Based on [bash-hello](https://github.com/NixOS/templates/blob/master/bash-hello/flake.nix)
# [Practical Nix flake anatomy: a guided tour of flake.nix](https://vtimofeenko.com/posts/practical-nix-flake-anatomy-a-guided-tour-of-flake.nix)
# [Flakes - nixos.wiki](https://nixos.wiki/wiki/Flakes)
# [The nix flake user manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake.html)
# [The nix flake references manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake)
# [Official Nix templates](https://github.com/NixOS/templates)
# [View 0xmycf's full-sized avatar
# [0xmycf my-nix-flake-templates](https://github.com/0xmycf/my-nix-flake-templates.git)
# [flake-utils](https://github.com/numtide/flake-utils)
# nix flake show templates
# nix flake init -t templates#bash-hello
# git add flake.nix # required otherwise it will not build
# nix build
# nix flake show # show the outputs provided by a flake
# nix flake [--debug] metadata .
# nix flake check -v # check whether the flake evaluates and run its tests
# nix flake metadata # show flake metadata
# nix develop # needs devshell (not provided here) run a bash shell that provides the build environment of a derivation
# Note: this flake does not provide attribute 'devShells.x86_64-linux.default', 'devShell.x86_64-linux', 'packages.x86_64-linux.default' or 'defaultPackage.x86_64-linux'
{
  description = "An over-engineered Hello World in bash";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlays.default ]; });

    in

    {
        overlays = {

      # A Nixpkgs overlay.
      default = final: prev: {

        hello = with final; stdenv.mkDerivation rec {
          name = "hello-${version}";

          unpackPhase = ":";

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
            '';
        };

      };
      };

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor.${system}) hello;
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.

      # A NixOS module, if applicable (e.g. if the package provides a system service).
      nixosModules.hello =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [ self.overlays.default ];

          environment.systemPackages = [ pkgs.hello ];

          #systemd.services = { ... };
        };

      # Tests run by 'nix flake check' and by Hydra.
      checks = forAllSystems
        (system:
          with nixpkgsFor.${system};

          {
            inherit (self.packages.${system}) hello;

            # Additional tests, if applicable.
            test = stdenv.mkDerivation {
              name = "hello-test-${version}";

              buildInputs = [ hello ];

              unpackPhase = "true";

              buildPhase = ''
                echo 'running some integration tests'
                [[ $(hello) = 'Hello Nixers!' ]]
              '';

              installPhase = "mkdir -p $out";
            };
          }

          // lib.optionalAttrs stdenv.isLinux {
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
          }
        );

    };
}
