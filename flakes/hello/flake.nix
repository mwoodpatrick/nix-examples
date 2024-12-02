# Create a new flake:
# 
#           | # nix flake new hello
#           | # cd hello
# 
#       · Build the flake in the current directory:
# 
#           | # nix build
#           | # ./result/bin/hello
#           | Hello, world!
# 
#       · Run the flake in the current directory:
# 
#           | # nix run
#           | Hello, world!
# 
#       · Start a development shell for hacking on this flake:
# 
#           | # nix develop
#           | # unpackPhase
#           | # cd hello-*
{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
