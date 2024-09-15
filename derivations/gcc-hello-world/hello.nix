# [Packaging GNU hello world](https://nixos.org/guides/nix-pills/08-generic-builders)
# [Derivations](https://nix.dev/manual/nix/2.18/language/derivations.html)
# cmd: 
#   wget https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gzwget https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz
#   nix-build hello.nix
#   result/bin/hello
let
  pkgs = import <nixpkgs> { };
in
derivation {
  name = "hello";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./hello_builder.sh ];
  inherit (pkgs)
    gnutar
    gzip
    gnumake
    gcc
    coreutils
    gawk
    gnused
    gnugrep
    ;
  # bintools = pkgs.binutils.bintools;
  src = ./hello-2.12.1.tar.gz;
  system = builtins.currentSystem;
}
