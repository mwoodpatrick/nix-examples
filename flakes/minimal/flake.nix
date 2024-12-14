# Create a minimal flake
#
# nix flake init
#
# Build the flake
#
# nix build
#
# nix run
#
{
  description = "A very basic flake";

  # Note that no explicit inputs are provided 
  # (comes from [public registry](https://github.com/NixOS/flake-registry)
  # legacyPackages are older packages maintained for stability of older configs
  outputs = { nixpkgs, self }: { packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.hello; };
}
