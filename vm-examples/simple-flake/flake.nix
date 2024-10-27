# [nix-build](https://nix.dev/manual/nix/2.24/command-ref/nix-build.html)
# build with: nixos-rebuild build-vm --flake .#westie-vm
# run with: ./result/bin/run-westie-vm
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      # test is a hostname for our machine
      nixosConfigurations.westie-vm = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./users.nix
        ];
      };
    };
}
