# nix run nixpkgs#cargo init rust-hello
# https://ryantm.github.io/nixpkgs/stdenv/stdenv/
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/make-derivation.nix
# Creating binary (application) package
# note: see more `Cargo.toml` keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html
let pkgs = import <nixpkgs> { };
in pkgs.stdenv.mkDerivation {
    src = "./rust-hello";
    name = "rust-hello-1.0";
    system = "x86_64-linux";
    nativeBuildInputs = [ pkgs.cargo ];
    # phases = [ "unpackPhase" "buildPhase" "installPhase" ]; # Removes all phases except buildPhase & installPhase
    unpackPhase = ''
        echo unpacking phase $PWD
        ls
        cp -pr rust-hello /build
    '';
    buildPhase = ''
      ls -Ral /build
      echo "Hello World"
      cat /build/env-vars
      cargo build --release
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp target/release/rust-hello $out/bin/rust-hello
      chmod +x $out
    '';
}
