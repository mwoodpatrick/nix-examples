# Example using none flake input
# nix build
#  ./result/bin/example
#       Hello world from none flake input!
# nix flake metadata
{
  description = "Using a none flake input";
  inputs = {
    nonFlakeInput = {
      url = "path:src";
      flake = false;
    };
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };
  outputs =
    {
      nonFlakeInput,
      nixpkgs-unstable,
      self,
    }:
    let
      pkgs = import nixpkgs-unstable { system = "x86_64-linux"; };
    in
    {
      packages.x86_64-linux.default = pkgs.runCommandLocal "example" { } ''
        mkdir -p $out/bin
        cp ${nonFlakeInput}/example $out/bin # "nonFlakeInput" will translate here to the /nix/store path where nonFlakeInput is placed during evaluation
        chmod +x $out/bin/example
      '';
    };
}
