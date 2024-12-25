# build: nixos-rebuild build-vm --flake .#my-first-gui
# run: ./result/bin/run-my-first-nixos-gui-vm
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      # test is a hostname for our machine
      nixosConfigurations.my-first-gui = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
        ];
      };
    };
}
