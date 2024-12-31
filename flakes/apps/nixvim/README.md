# Nixvim template

This template gives you a good starting point for configuring nixvim standalone.

## Setup

Create using

```
    nix flake init --template github:nix-community/nixvim
```

## Configuring

To start configuring, just add or modify the nix files in `./config`.
If you add a new configuration file, remember to add it to the
[`config/default.nix`](./config/default.nix) file

## Testing your new configuration

To test your configuration simply run the following command

```
nix run .
```

# References

1. [Nixvim: Neovim Distro Powered By Nix](https://www.youtube.com/watch?v=b641h63lqy0)
2. [All code blocks from the video](https://github.com/vimjoyer/nixvim-video)
3. [nixvim docs](https://nix-community.github.io/nixvim/)


