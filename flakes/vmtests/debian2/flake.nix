# [nix-vm-test: reproducible integration tests](https://numtide.com/blog/nix-vm-test-reproducible-integration-tests/)
# nix run
# time nix flake check -L
# nix flake check
# nix run .#
# nix run .#myTest
{
  # Load the dependencies
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vm-test.url = "github:numtide/nix-vm-test";
  };

  outputs = { self, nixpkgs, nix-vm-test }:
    let
      lib = nix-vm-test.lib.x86_64-linux;
      # Create a test for Debian 13
      myTest = lib.debian."13" {
        sharedDirs = {
          dir1 = {
            # This makes the current folder available in the test at /tmp/dir1
            source = "${self}";
            target = "/tmp/dir1";
          };
        };
        # A synthetic test
        testScript = ''
          # Wait for the system to be fully booted
          vm.wait_for_unit("multi-user.target")
          # Test that the mount worked
          vm.succeed('ls /tmp/dir1')
          # Test that flake.nix contains the string "FLOB"
          vm.succeed('grep FLOB /tmp/dir1/flake.nix')
        '';
      };
    in
    {
      # Run the sandboxed run with `nix flake check`
      checks.x86_64-linux.myTest = myTest.sandboxed;
      # Spins up an interactive environment with `nix run .#`
      packages.x86_64-linux.default = myTest.driverInteractive;
      # Run the non-sandboxed environment with `nix run .#myTest`
      packages.x86_64-linux.myTest = myTest.driver;
    };
}
