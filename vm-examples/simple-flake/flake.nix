
# [Practical Nix flake anatomy: a guided tour of flake.nix#nixosConfigurations](https://vtimofeenko.com/posts/practical-nix-flake-anatomy-a-guided-tour-of-flake.nix/#nixosconfigurations)
# [Debugging with nix repl](https://nixos-and-flakes.thiscute.world/best-practices/debugging#debugging-with-nix-repl)
# [Learn how to use the Nix REPL effectively](https://aldoborrero.com/posts/2022/12/02/learn-how-to-use-the-nix-repl-effectively)
# [Modularize Your NixOS Configuration](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration)
# [NixOS "Stoat" 23.05](https://www.youtube.com/watch?v=79-O7sQxHwk)
# [mpickering/configuration.nix](https://gist.github.com/mpickering/a3be96e06105e58355b5659dffb8c47e)
# [NixOS/nixpkgs](https://github.com/NixOS/nixpkgs.git)
# [mwoodpatrick/nixpkgs](https://github.com/mwoodpatrick/nixpkgs.git)
# [nix-community/home-manager](https://github.com/nix-community/home-manager)
# [mwoodpatrick/home-manager](https://github.com/mwoodpatrick/home-manager)
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# [Build Your World](https://mynixos.com/)
# [virtualisation](https://mynixos.com/nixpkgs/options/virtualisation)
# [NixOS VM tests](https://wiki.nixos.org/wiki/NixOS_VM_tests)
# [nix qemu_opts](https://www.bing.com/search?q=nix+qemu_opts&form=ANNTH1&refig=bb4425c4b7b84dcab2dd47dc4bbb64a8&pc=W147&adppc=EDGEDBB&pq=nix&pqlth=3&assgl=13&sgcn=nix+qemu_opts&qs=HS&smvpcn=0&swbcn=10&sc=10-3&sp=3&ghc=0&cvid=bb4425c4b7b84dcab2dd47dc4bbb64a8&clckatsg=1&hsmssg=0)
# [qemu-vm.nix](https://github.com/NixOS/nixpkgs/blob/7eee17a8a5868ecf596bbb8c8beb527253ea8f4d/nixos/modules/virtualisation/qemu-vm.nix)
# [virtualisation.qemu.drives.*](https://mynixos.com/options/virtualisation.qemu.drives.*)
# [qemu-guest-agent.nix](https://github.com/NixOS/nixpkgs/blob/7eee17a8a5868ecf596bbb8c8beb527253ea8f4d/nixos/modules/virtualisation/qemu-guest-agent.nix)
# [QEMU/Documentation/9psetup](https://wiki.qemu.org/Documentation/9psetup)
# [nix-build](https://nix.dev/manual/nix/2.24/command-ref/nix-build.html)
# build with: nixos-rebuild build-vm --flake .#westie-vm
# build guest: 
#              nix build ./#nixosConfigurations.westie-vm.config.system.build.vm 
#              nixos-rebuild build-vm --flake .#westie-vm
# run with: ./result/bin/run-westie-vm
# Access via: spicy -h localhost -p 5924
# ssh with: ssh -p 8022 mwoodpatrick@127.0.0.1
# wget with: wget http://127.0.0.1:8080
{
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs :
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.westie-vm = nixpkgs.lib.nixosSystem {
        inherit system;

        # Set all inputs parameters as special arguments for all submodules,
        # so you can directly use all dependencies in inputs in submodules
        specialArgs = { inherit inputs; };

        # This module works the same as the `specialArgs` parameter we used above
        # choose one of the two methods to use
        # { _module.args = { inherit inputs; };}

        modules = [
          ./configuration.nix
          ./users.nix
          ./ui.nix

          # [Home Manager](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager)
          # [Home Manager - NixOS module](https://nix-community.github.io/home-manager/#sec-install-nixos-module)
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            # home-manager.logLevel = "debug";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.mwoodpatrick = import ./home.nix;

#            home-manager.home.autostart = {
#                https://home-manager-options.extranix.com/?query=xsession.windowManager.i3.config&release=master
#                mwoodpatrick = {
#                    name = "MATE Terminal";
#                    exec = "mate-terminal";
#                    terminal = false;
#                };
#            };

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
}
