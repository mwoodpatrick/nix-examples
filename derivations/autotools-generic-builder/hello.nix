# [A generic builder](https://nixos.org/guides/nix-pills/08-generic-builders)
# [Derivations](https://nix.dev/manual/nix/2.18/language/derivations.html)
# [Packaging GNU hello world](https://nixos.org/guides/nix-pills/08-generic-builders)
# cmd: 
#   wget https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gzwget https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz
#   nix-build hello.nix
#   result/bin/hello
let
  pkgs = import <nixpkgs> { };
  mkDerivation = import ./autotools.nix pkgs;
in
mkDerivation {
  name = "hello";
  src = ./hello-2.12.1.tar.gz;
}
