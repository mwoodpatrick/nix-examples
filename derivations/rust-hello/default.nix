# nix run nixpkgs#cargo init rust-hello
# https://ryantm.github.io/nixpkgs/stdenv/stdenv/
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/make-derivation.nix
# Creating binary (application) package
# note: see more `Cargo.toml` keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html
# [Working with local files](https://nix.dev/tutorials/working-with-local-files.html)
# [Sandbox isolated environment](https://nix.dev/manual/nix/2.24/command-ref/conf-file.html#conf-sandbox)
# [lib.fileset: file set functions](https://ryantm.github.io/nixpkgs/functions/library/fileset/)
#
# Create a derivation for build:
#
#   nix-instantiate
#
# View the generated derivation:
#
#   nix derivation show <derrivation>
#
# Build the package:
#
#   nix-build
#
# Add -v (possibly multiple times to increase verbosity)
#
# Display build log:
#
#   nix log <store path>
#
# Create a shell in the build environment for the package:
#
#   nix-shell

let 
    nixpkgs = import <nixpkgs> { };
    lib = nixpkgs.lib;
    fs = lib.fileset;
    debug = lib.debug;
    sourceFiles = fs.toSource {
                root = ./.;
                fileset = ./rust-hello;
      };
      ts = builtins.typeOf(sourceFiles);
in builtins.trace "Creating Hello ${sourceFiles} ${builtins.typeOf(sourceFiles)}" (fs.trace ./rust-hello)
# in builtins.trace "Creating Hello ${ts} " (fs.trace ./rust-hello)
nixpkgs.stdenv.mkDerivation {
    src = sourceFiles;
    name = "rust-hello-1.0";
    system = "x86_64-linux";
    nativeBuildInputs = [ nixpkgs.cargo ];
    buildPhase = ''
      ls -Ral /build
      echo "Hello World"
      cat /build/env-vars
      cd rust-hello
      pwd
      cargo build --release
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp target/release/rust-hello $out/bin/rust-hello
      chmod +x $out
    '';
}
