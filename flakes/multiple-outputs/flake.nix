{
  description = "Example Nix Flake with various attributes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = nixpkgs.lib.mkShell {
      buildInputs = [ nixpkgs.hello ];
    };
    apps = {
      default = {
        type = "app";
        program = "${self.packages.x86_64-linux}/bin/hello";
      };
    };
    overlays = [
      (final: prev: {
        custom-hello = prev.hello.overrideAttrs (old: {
          name = "custom-hello";
          version = "1.0.0";
        });
      })
    ];
    devShell = nixpkgs.mkShell {
      buildInputs = [ nixpkgs.hello ];
    };
    checks.x86_64-linux = self.packages.x86_64-linux;
  };
}
