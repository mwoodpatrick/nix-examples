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
    nixpkgs = import <nixpkgs> {};
    lib = nixpkgs.lib;
    fs = lib.fileset;
    debug = lib.debug;
    sourceFiles = fs.toSource {
                root = ./.;
                fileset = ./hello.c;
      };

	build = { stdenv, lib }:
    builtins.trace "Creating Hello" (fs.trace ./hello.c)
	( stdenv.mkDerivation rec {
	  pname = "hello";
	  version = "1.0";
      src = sourceFiles;
      enableDebugging = false; # prevent stripping of debug symbols
	  buildInputs = [ stdenv.cc ];
	
	  buildPhase = ''
        echo ${stdenv.cc}/bin/cc -o hello ${src}
	    ${stdenv.cc}/bin/cc -o hello ${src}/hello.c
	  '';
	
	  installPhase = ''
	    mkdir -p $out/bin
	    cp hello $out/bin/
	  '';
	});
in
    build { stdenv = nixpkgs.pkgs.stdenv; lib=lib; }
