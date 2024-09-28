# [Practical Nix flake anatomy: a guided tour of flake.nix](https://vtimofeenko.com/posts/practical-nix-flake-anatomy-a-guided-tour-of-flake.nix/)
# [Flakes - nixos.wiki](https://nixos.wiki/wiki/Flakes)
# [The nix flake user manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake.html)
# [The nix flake references manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake)
# [Official Nix templates](https://github.com/NixOS/templates)
# nix flake show templates
# nix flake init -t templates#bash-hello
# git add flake.nix # required otherwise it will not build
# nix build
# nix flake show
# nix flake [--debug] metadata .
# nix flake check
# nix develop
{
  description = "An over-engineered Hello World in bash";

  # Nixpkgs / NixOS version to use.
  # [The nix flake inputs manual](https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-flake.html#flake-inputs)
  inputs.nixpkgs.url = "nixpkgs/nixos-21.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

# self - the flake being created
# evaluated inputs 
  outputs = args@{ self, flake-utils, nixpkgs }:
  #{ nixpkgs, ... }@args: [would also work](https://nix.dev/tutorials/nix-language.html#named-attribute-set-argument)
   flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { system = "${system}"; };
        legacyPackages = nixpkgs.legacyPackages.${system};

        # to work with older version of flakes
        lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

        # Generate a user-friendly version number.
        version = builtins.substring 0 8 lastModifiedDate;
      
        # System types to support.
        supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      in rec {
        hello = pkgs.stdenv.mkDerivation rec {
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

        # A Nixpkgs overlay.
        # [Overlays - nixos.wiki](https://nixos.wiki/wiki/Overlays)
        overlays.default = final: prev: {
    
        };

        packages = rec {
          hello = legacyPackages.hello;
          default = hello;
        };

        ##  packages.mydefault = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; }

        # A NixOS module, if applicable (e.g. if the package provides a system service).
        # [NixOS modules](https://nixos.wiki/wiki/NixOS_modules)
        # Nix Modules are used to extend Nix OS
        nixosModules.hello =
          { config, pkgs, ... }:
          {
            nixpkgs.overlays = [ self.overlays.default ];
  
            environment.systemPackages = [ pkgs.hello ];
  
            #systemd.services = { ... };
          };

        # Tests run by 'nix flake check' and by Hydra.
        checks = {
            # Additional tests, if applicable.
            test = pkgs.stdenv.mkDerivation {
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

        // nixpkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
            # A VM test of the NixOS module.
            vmTest =
              # with import (nixpkgs + "/nixos/lib/testing-python.nix") {
              #  inherit system;
              # };

              pkgs.makeTest {
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
        });
 }
