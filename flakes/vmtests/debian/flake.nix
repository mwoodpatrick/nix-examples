# [Getting Started - nix-vm-test](https://github.com/numtide/nix-vm-test/blob/main/doc/getting-started.md)
#
# nix run
# nix run .#hello
# nix run .#test-vm
# nix run .#test-vm-interactive
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
        vmTest = nix-vm-test.lib.x86_64-linux.debian."13" {

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
        in {
            packages.x86_64-linux = rec {
                hello = nixpkgs.legacyPackages.x86_64-linux.hello;
                test-vm = vmTest.driver;
                test-vm-interactive = vmTest.driverInteractive;
                default = test-vm;
            };
        };
}
