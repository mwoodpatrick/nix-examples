# [Modularize Your NixOS Configuration](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration)
# [NixOS "Stoat" 23.05](https://www.youtube.com/watch?v=79-O7sQxHwk)
# [NixOS/nixpkgs](https://github.com/NixOS/nixpkgs.git)
# [mwoodpatrick/nixpkgs](https://github.com/mwoodpatrick/nixpkgs.git)
# [nix-community/home-manager](https://github.com/nix-community/home-manager)
# [mwoodpatrick/home-manager](https://github.com/mwoodpatrick/home-manager)
# build guest: nix build  ./#nixosConfigurations.vm.config.system.build.vm
# run guest: result/bin/run-nixos-vm
{
  description = "VM";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
    } @ inputs :
    {
      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./vm.nix ];
        # modules = [ ./nixos/configuration.nix ];
      };
    };
}
