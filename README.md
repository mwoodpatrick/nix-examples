# nix-examples
A simple set of nix examples &amp; experiments

# Nix Repl

[Nix Pills](https://nixos.org/guides/nix-pills/00-preface)
[Nix Reference Manual](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-repl)

# Overlays

See [Mastering Nixpkgs Overlays: Techniques and Best Practice](https://nixcademy.com/posts/mastering-nixpkgs-overlays-techniques-and-best-practice/)

directory simple-overlay

In the REPL:
```

$ nix repl

nix-repl> map (x: x * 2) [1 2 3]
    [ 2 4 6 ]

pkgs = import ~/src/nixpkgs { 
  overlays = [
    someOverlayFunction
  ];
  config = { };
}
```
