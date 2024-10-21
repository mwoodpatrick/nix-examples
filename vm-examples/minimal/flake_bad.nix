{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  # } @ inputs: 
} :

  # let
  #   inherit (self) outputs;
  # in {
      {
      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./nixos/configuration.nix ];
      };

#     # NixOS configuration entrypoint
#     # nix build  ./#nixosConfigurations.vm.config.system.build.vm
#     # Available through 'nixos-rebuild --flake .#your-hostname'
#       # FIXME replace with your hostname
#       your-hostname = nixpkgs.lib.nixosSystem {
#         specialArgs = {inherit inputs outputs;};
#         # > Our main nixos configuration file <
#         modules = [./nixos/configuration.nix];
#       };
#     };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
#     homeConfigurations = {
#       # FIXME replace with your username@hostname
#       "your-username@your-hostname" = home-manager.lib.homeManagerConfiguration {
#         pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
#         extraSpecialArgs = {inherit inputs outputs;};
#         # > Our main home-manager configuration file <
#         modules = [./home-manager/home.nix];
#       };
#     };
  };
}
