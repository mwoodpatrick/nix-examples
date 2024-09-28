# [Flakes - nixos.wiki](https://nixos.wiki/wiki/Flakes)
# [The nix flake user manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake.html)
# [The nix flake references manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake)
# [Official Nix templates](https://github.com/NixOS/templates)
# nix flake show templates
# nix flake init -t templates#bash-hello
# git add flake.nix # required otherwise it will not build
# nix build
# nix flake check
{
  description = "An over-engineered Hello World in bash";

  # Nixpkgs / NixOS version to use.
  # [The nix flake inputs manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake.html#flake-inputs)
  inputs.nixpkgs.url = "nixpkgs/nixos-21.05";

# self - the flake being created
# evaluated inputs 
  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      # [genAttrs - reference](https://ryantm.github.io/nixpkgs/functions/library/attrsets/#function-library-lib.attrsets.genAttrs)
      # Takes a list of attribute names and a function that maps names to values and returns 
      # an attribute set mapping specified names to mapped values
      # In this case the created attribute set maps system names to the package for that system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

    in

    {

      # A Nixpkgs overlay.
      # [Overlays - nixos.wiki](https://nixos.wiki/wiki/Overlays)
      overlay = final: prev: {

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

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor.${system}) hello;
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.hello);

      # A NixOS module, if applicable (e.g. if the package provides a system service).
      # [NixOS modules](https://nixos.wiki/wiki/NixOS_modules)
      # Nix Modules are used to extend Nix OS
      nixosModules.hello =
        { config, pkgs, ... }:
        {
          nixpkgs.overlays = [ self.overlay ];

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
