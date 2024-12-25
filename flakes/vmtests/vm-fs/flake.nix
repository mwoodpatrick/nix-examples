{
  description = "NixOS VM with specified filesystem sizes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ config, pkgs, ... }: {
          imports = [ "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix" ];

          virtualisation.memorySize = 2048; # 2GB RAM
          virtualisation.cores = 2; # 2 CPU cores

          fileSystems."/" = {
            device = "/dev/sda1";
            fsType = "ext4";
            options = [ "defaults" ];
          };

          fileSystems."/home" = {
            device = "/dev/sda2";
            fsType = "ext4";
            options = [ "defaults" ];
          };

          fileSystems."/var" = {
            device = "/dev/sda3";
            fsType = "ext4";
            options = [ "defaults" ];
          };

          fileSystems."/tmp" = {
            device = "tmpfs";
            fsType = "tmpfs";
            options = [ "size=4G" ]; # Set the size to 4GB
          };

          # Additional configurations can be added here
        })
      ];
    };
  };
}

