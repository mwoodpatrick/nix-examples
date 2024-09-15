# [Automatic Runtime Dependencies](https://nixos.org/guides/nix-pills/09-automatic-runtime-dependencies)
# [Derivations](https://nix.dev/manual/nix/2.18/language/derivations.html)
# [Packaging GNU hello world](https://nixos.org/guides/nix-pills/08-generic-builders)
# cmd: 
#   wget https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gzwget https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz
#   nix-build hello.nix
#)   result/bin/hello

# [instantiate store derivations from Nix expressions](https://nix.dev/manual/nix/2.18/command-ref/nix-instantiate.html)
#
#   nix-instantiate hello.nix
#
# [show the contents of a store derivation](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-derivation-show)
# 
#   nix derivation show /nix/store/m2w8q7avsgngddgp98dwvniy0q1g7dan-hello.drv
#
# Build [store derivations](https://3ddnix.dev/manual/nix/2.18/glossary#gloss-store-derivation) produced by (nix-instantiate:)[https://nix.dev/manual/nix/2.18/command-ref/nix-instantiate]
#
#   [nix-store --realise](https://nix.dev/manual/nix/2.18/command-ref/nix-store/realise) $(nix-instantiate ./test.nix)
#
# Determine runtime dependencies:
#
# Prints the set of (references)[https://nix.dev/manual/nix/2.18/command-ref/nix-store/query] 
# of the store paths paths, that is, their immediate dependencies. (For all de‐pendencies, use --requisites.)
#
#   nix-store -q --references $(nix-instantiate hello.nix)
#
#   nix-store -q --references $(nix-store -r $(nix-instantiate hello.nix))
#       /nix/store/r8qsxm85rlxzdac7988psm7gimg4dl3q-glibc-2.39-52
#       /nix/store/qksd2mz9f5iasbsh398akdb58fx9kx6d-gcc-13.2.0-lib
#       /nix/store/yp441ann6ch705yk708h61ywxn7ayhj3-glibc-2.39-52-dev
#       /nix/store/skkw2fidr9h2ikq8gzgfm6rysj1mal0r-gcc-13.2.0
#       /nix/store/w12vjrbwh8wxzmwh49pam082pmxchw41-hello
#
#   strings result/bin/hello|grep gcc
#
#   ldd result/bin/hello
#
#       linux-vdso.so.1 (0x00007ffd40d71000)
#       libc.so.6 => /nix/store/r8qsxm85rlxzdac7988psm7gimg4dl3q-glibc-2.39-52/lib/libc.so.6 (0x00007fe0c6431000)
#       /nix/store/r8qsxm85rlxzdac7988psm7gimg4dl3q-glibc-2.39-52/lib/ld-linux-x86-64.so.2 => /nix/store/r8qsxm85rlxzdac7988psm7gimg4dl3q-glibc-2.39-52/lib64/ld-linux-x86-64.so.2 (0x00007fe0c6620000)
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
