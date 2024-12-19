# [Getting Started - nix-vm-test](https://github.com/numtide/nix-vm-test/blob/main/doc/getting-started.md)
{
  description = "A very basic flake";

  # Load the dependencies

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vm-test.url = "github:numtide/nix-vm-test";
  };

  outputs = { self, nixpkgs, nix-vm-test }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    # Create a test for Debian 13
    packages.x86_64-linux.test-vm =
      let
        vmTest = nix-vm-test.lib.x86_64-linux.debian."13" {

          # This makes the current folder available in the test at /mnt/debdir

          sharedDirs = {
            debDir = {
              source = "${./.}";
              target = "/mnt/debdir";
            };
          };

          # A synthetic test

          testScript = ''
            # Wait for the system to be fully booted

            vm.wait_for_unit("multi-user.target")

            # Test that the mount worked

            vm.succeed('ls /mnt/debdir')

            # Test that the package installs

            vm.succeed("apt-get -yq install /mnt/debdir/hello.deb")
          '';
        };
        in vmTest.driver; # vmTest.driverInteractive;

    packages.x86_64-linux.default = self.packages.x86_64-linux.test-vm;
  };
}
