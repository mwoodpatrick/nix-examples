# [Automatic Runtime Dependencies](https://nixos.org/guides/nix-pills/09-automatic-runtime-dependencies)
# [Derivations](https://nix.dev/manual/nix/2.18/language/derivations.html)
# [Packaging GNU hello world](https://nixos.org/guides/nix-pills/08-generic-builders)
# cmd: 
#   wget https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gzwget https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz
#   nix-build hello.nix
#   result/bin/hello
#   nix-store -q --references result
#   ldd result/bin/hello
#
# To delete the build result do:
#
#   ls -l result
#   nix-store --delete /nix/store/w12vjrbwh8wxzmwh49pam082pmxchw41-hello
#   nix-collect-garbage
#
# see: [How to undo nix-build](https://discourse.nixos.org/t/how-to-undo-nix-build/5433)
let
  pkgs = import <nixpkgs> { };
  mkDerivation = import ./autotools.nix pkgs;
in
mkDerivation {
  name = "hello";
  src = ./hello-2.12.1.tar.gz;
}
