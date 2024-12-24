# [Wombat’s Book of Nix](https://mhwombat.codeberg.page/nix-book)
# See https://github.com/mhwombat/nix-for-numbskulls/blob/main/flakes.md
# [Getting Started - nix-vm-test](https://github.com/numtide/nix-vm-test/blob/main/doc/getting-started.md)
# [nix-vm-test](https://github.com/numtide/nix-vm-test)
#
# nix build .#myhello 2>&1 | tee build.log
# [nix build](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-build)
#
# nix log .#myhello |less
# [nix log](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-log)
#
# nix derivation show .#myhello|less
# [Our First Derivation](https://nixos.org/guides/nix-pills/06-our-first-derivation)
# [nix derivation](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-derivation)
# [nix run](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-run)
# nix run .#hello
# nix run .#test-vm
# nix run .#test-vm-interactive
# [nix flake check](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-check)
# [nix flake show](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-show)
# [nix flake metadata](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-metadata)
{
  description = "A template that shows all standard flake outputs";

  # Load the dependencies

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vm-test = {
      url = "github:mwoodpatrick/nix-vm-test?rev=7ab28725372bee62d8fb1d68010888fcd4ec7fcb";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nix-vm-test, flake-utils }:
    # Create a test for Debian 13
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
        distro = "debian";
        versions = {
            debian = ["13" "12"];
            ubuntu = ["23_10" "22_04"];
            fedora = ["41" "40" "39" "38" ];
        };
        version = "13";

        vmTest = { system, distro, version  } : nix-vm-test.lib.${system}.${distro}.${version} {

          # This makes the guest-shared folder available in the test at /mnt/host-shared

          sharedDirs = {
            debDir = {
              source = "${./guest-shared}";
              target = "/mnt/host-shared";
            };
          };

          # A synthetic test

          testScript = ''
            # Wait for the system to be fully booted

            vm.wait_for_unit("multi-user.target")

            # Test that the mount worked

            vm.succeed('ls /mnt/host-shared')

            # run the tests

            vm.succeed('/mnt/host-shared/tests.bash')
          '';
        };

          vmTestv = { system?"x86_64-linux", distro?"debian", version?null, diskSize?"+1G", ... }@fattr :
            let 
                _distro = if versions ? ${distro} then distro else throw "Unsupported distro: ${ distro }";
                _version = if isNull version then builtins.elemAt versions.${_distro} 0 else
                    if builtins.elem version versions.${_distro} then version else 
                        throw "Unsupported version ${version} for distro: ${ toString distro }";
                var = builtins.trace "system=${system}; distro=${_distro} version=${_version}; " 
                    vmTest { system = system; distro = _distro; version = _version; } ;
               in var;

            myHello = pkgs.stdenv.mkDerivation {
                    pname = "myhello";
                    version = "2.10";
                  
                    src = pkgs.fetchurl {
                      url = "https://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz";
                      sha256 = "sha256-MeBmE3qWJnbon2nRtlOC3pWn732RS4y5VvQepy4PUWs=";
                    };
                  
                    buildInputs = [ pkgs.gcc ];
                    buildPhase = ''
                      mkdir -p $out/bin
                      env > $out/build.env
                      ls -Ral > $out/ls.log
                      ./configure
                      echo "*** doing make in $PWD ***"
                      make
                      ls -al
                    '';
                    installPhase = ''
                      echo "*** In $PWD copying build products to $out ***"
                      ls -Ral > $out/ls_install.log
                      cp hello $out/bin
                      cp -pr tests doc man hello.1 NEWS README* $out
                    '';
                  };

        in {
            # Run the sandboxed run with `nix flake check`
            checks.x86_64-linux.myTest = (vmTestv {distro=distro;}).sandboxed;

            packages.x86_64-linux = rec {
                bash_hello = pkgs.stdenv.mkDerivation rec {
                  name = "hello_flake";
      
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
                hello = nixpkgs.legacyPackages.x86_64-linux.hello;
                myhello = myHello;
                test-vm = (vmTestv {distro=distro;}).driver;
                test-vm-interactive = (vmTestv {distro=distro;}).driverInteractive;
                test-vm-sandboxed = (vmTestv {distro=distro;}).sandboxed;
                debian-test-vm = (vmTestv {distro="debian";}).driver;
                debian-test-vm-interactive = (vmTestv {distro="debian";}).driverInteractive;
                fedora-test-vm = (vmTestv {distro="fedora";}).driver;
                fedora-test-vm-interactive = (vmTestv {distro="fedora";}).driverInteractive;
                ubuntu-test-vm = (vmTestv {distro="ubuntu";}).driver;
                ubuntu-test-vm-interactive = (vmTestv {distro="ubuntu";}).driverInteractive;
                default = test-vm;
            };

            apps = rec {
              # bash_hello = flake-utils.lib.mkApp { drv = self.packages.x86_64-linux.bash_hello; };
              bash_hello = flake-utils.lib.mkApp { drv = self.packages.x86_64-linux.bash_hello; };
# self.packages.x86_64-linux.bash_hello; };
              default = bash_hello;
            };

            debug = _: let var = builtins.trace "foo" "bar"; in var;
            test-vm = vmTestv {distro=distro;};

            myself = self;

            inherit versions vmTestv;
        
        };
}
