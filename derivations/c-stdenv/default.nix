# https://nix.dev/tutorials/working-with-local-files.html
# https://ryantm.github.io/nixpkgs/functions/library/fileset/
let
    nixpkgs = import <nixpkgs> {};
    lib = nixpkgs.lib;
    fs = lib.fileset;
    sourceFiles = ./hello.c;
    # fs.trace sourceFiles;

	build = { stdenv, lib }:
	stdenv.mkDerivation rec {
	  pname = "hello";
	  version = "1.0";
	
      src = fs.toSource {
                root = ./.;
                fileset = sourceFiles;
      };
	
	  buildInputs = [ stdenv.cc ];
	
	  buildPhase = ''
        echo ${stdenv.cc}/bin/cc -o hello ${src}
	    ${stdenv.cc}/bin/cc -o hello ${src}/hello.c
	  '';
	
	  installPhase = ''
	    mkdir -p $out/bin
	    cp hello $out/bin/
	  '';
	};
in
    build { stdenv = nixpkgs.pkgs.stdenv; lib=lib; }
