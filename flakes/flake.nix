# Example using none flake input
# nix build
#  ./result/bin/example
#       Hello world from none flake input!
# nix flake metadata
{
  description = "Using a none flake input";
  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };
  outputs =
    {
      nixpkgs-unstable,
      self,
    }:
    let
      pkgs = import nixpkgs-unstable { system = "x86_64-linux"; };
    in
    {
        myself=self;
    };
}
