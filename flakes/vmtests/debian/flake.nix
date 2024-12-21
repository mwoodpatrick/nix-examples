# [Getting Started - nix-vm-test](https://github.com/numtide/nix-vm-test/blob/main/doc/getting-started.md)
# [nix-vm-test](https://github.com/numtide/nix-vm-test)
#
# [nix build](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-build)
# [nix run](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-run)
# nix run .#hello
# nix run .#test-vm
# nix run .#test-vm-interactive
# [nix flake check](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-check)
# [nix flake show](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-show)
# [nix flake metadata](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-metadata)
{
  description = "A very basic flake";

  # Load the dependencies

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vm-test.url = "github:numtide/nix-vm-test";
  };

  outputs = { self, nixpkgs, nix-vm-test }:
    # Create a test for Debian 13
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
        distro = "debian";
        versions = {
            debian = ["12" "13"];
            ubuntu = ["23_10" "22_04"];
            fedora = ["41" "40" "39" ];
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

            # execute the tests

            vm.succeed('/mnt/host-shared/tests.bash')

            # Test that the package installs

            vm.succeed("apt-get -yq install /mnt/host-shared/hello.deb")
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

        in {
            # Run the sandboxed run with `nix flake check`
            checks.x86_64-linux.myTest = vmTest.sandboxed;

            packages.x86_64-linux = rec {
                hello = nixpkgs.legacyPackages.x86_64-linux.hello;
                test-vm = (vmTestv {distro=distro;}).driver;
                test-vm-interactive = (vmTestv {distro=distro;}).driverInteractive;
                debian-test-vm = (vmTestv {distro="debian";}).driver;
                debian-test-vm-interactive = (vmTestv {distro="debian";}).driverInteractive;
                fedora-test-vm = (vmTestv {distro="fedora";}).driver;
                fedora-test-vm-interactive = (vmTestv {distro="fedora";}).driverInteractive;
                default = test-vm;
            };

            debug = _: let var = builtins.trace "foo" "bar"; in var;
            test-vm = vmTestv {distro=distro;};

            inherit versions vmTestv;
        
        };
}
