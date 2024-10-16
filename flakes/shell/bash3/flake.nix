{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

#  outputs = { self, nixpkgs }: {
#
#    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
#
#    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
#
#  };

  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system: {
        default = (nixpkgsFor.${system}) hello;
      });
    };
}
