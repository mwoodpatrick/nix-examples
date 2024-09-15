# [Working Derivation](https://nixos.org/guides/nix-pills/07-working-derivation)
# [Derivations](https://nix.dev/manual/nix/2.18/language/derivations.html)
# cmd: nix-build simple.nix

let
  pkgs = import <nixpkgs> { };
in
derivation {
  name = "simple";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./simple_builder.sh ];
  gcc = pkgs.gcc;
  coreutils = pkgs.coreutils;
  src = ./simple.c;
  system = builtins.currentSystem;
}
