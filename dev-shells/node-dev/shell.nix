# [Declarative shell environments with shell.nix](https://nix.dev/tutorials/first-steps/declarative-shell)
# [Automatic environment activation with direnv](https://nix.dev/guides/recipes/direnv#automatic-direnv)
#
# example development shell providing node
#
# To Enter development shell run:
#
#   nix-shell
#
# In development shell run:
#
#   node --version
#
# Automate the loading of the shell by doing:
#
#  echo "use nix" > .envrc && direnv allow
#
# cd'ing into the project directory will cause the shell to load automatically

let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

# mkShellNoCC is a function that produces such an environment, but without a compiler toolchain.
pkgs.mkShellNoCC {
  packages = with pkgs; [
    cowsay
    lolcat
    neovim
    vim
    nodejs_23
  ];

# Any attribute name passed to mkShellNoCC that is not reserved otherwise 
# and has a value which can be coerced to a string will end up as an environment variable.
  GREETING = "Hello, Nix!";

# Specify any startup commands

  shellHook = ''
    echo $GREETING | cowsay | lolcat
    echo "Using node version: $(node --version)"
  '';
}
