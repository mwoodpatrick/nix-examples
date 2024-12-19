# [Getting Started - nix-vm-test](https://github.com/numtide/nix-vm-test/blob/main/doc/getting-started.md)
{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vm-test.url = "github:numtide/nix-vm-test";
  };

  outputs = { self, nixpkgs, nix-vm-test }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    packages.x86_64-linux.test-vm =
      let
        vmTest = nix-vm-test.lib.x86_64-linux.debian."13" {
          sharedDirs = {
            debDir = {
              source = "${./.}";
              target = "/mnt/debdir";
            };
          };
          testScript = ''
            vm.wait_for_unit("multi-user.target")
            vm.succeed("apt-get -yq install /mnt/debdir/hello.deb")
          '';
        };
        in vmTest.driver; # vmTest.driverInteractive;

    packages.x86_64-linux.default = self.packages.x86_64-linux.test-vm;
  };
}
