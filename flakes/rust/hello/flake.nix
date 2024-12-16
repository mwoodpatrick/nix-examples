# nix run nixpkgs#cargo init rust-hello
# https://ryantm.github.io/nixpkgs/stdenv/stdenv/
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/make-derivation.nix
# Creating binary (application) package
# note: see more `Cargo.toml` keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html
# [Working with local files](https://nix.dev/tutorials/working-with-local-files.html)
# [Sandbox isolated environment](https://nix.dev/manual/nix/2.24/command-ref/conf-file.html#conf-sandbox)
# [lib.fileset: file set functions](https://ryantm.github.io/nixpkgs/functions/library/fileset/)
#
# Enter development environment (automatic due to .envrc)
#
# get cargo's current version:
#
#   cargo --version
#       cargo 1.82.0 (8f40fc59f 2024-08-21)
#
# Create new project:
#
#   cargo new rust-hello
#
#     Creating binary (application) `rust-hello` package
#     note: see more `Cargo.toml` keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html
#
# Edit source
#
#  nvim rust-hello/src/main.rs
#
# Run debug version (add --release for release version)
# 
#   cd rust-hello/
#   cargo run
#       Hello, world from rust in Nix!
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

{
  description = "a very simple and friendly rust flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = nixpkgs.lib;
        fs = lib.fileset;
        debug = lib.debug;
        srcPath = ./rust-hello;
        sourceFiles = fs.toSource {
                root = ./.;
                fileset = srcPath;
        };
        buildInputs = [ pkgs.cowsay pkgs.cargo ];
        ts = builtins.typeOf(sourceFiles);
# in builtins.trace "Creating Hello my source Files: ${sourceFiles} typeof source files: ${builtins.typeOf(sourceFiles)} type of srcPath: ${builtins.typeOf(srcPath)}" (fs.trace ./rust-hello);
# in builtins.trace "Creating Hello ${ts} " (fs.trace ./rust-hello);
      in
      {
        devShells = rec {
          default = pkgs.mkShell {
            packages = buildInputs;
          };
        };

        packages = rec {
          rust-hello = pkgs.stdenv.mkDerivation rec {
            # import system;
            name = "rust-hello-flake";
            pname = "hello-rust";
            version = "0.1";
            src = sourceFiles;
            nativeBuildInputs = buildInputs;

            unpackPhase = "true";

            buildPhase = ''
              set -x
              ls -Ral /build
              echo "Hello World"
              cat /build/env-vars
              echo "**** got here $PWD"
              cowsay `ls -Ral $src`
              cargo build --release --manifest-path $src/rust-hello/Cargo.toml --lockfile-path ./Cargo.lock
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp target/release/rust-hello $out/bin/rust-hello
              chmod +x $out
            '';
          };
          default = rust-hello;
        };

        apps = rec {
          rust-hello = flake-utils.lib.mkApp { drv = self.packages.${system}.rust-hello; };
          default = rust-hello;
        };
      }
    );
}
