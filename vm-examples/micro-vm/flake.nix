# Build this VM with: nixos-rebuild build-vm --flake .#my-microvm
# Then rim it with: nix run .#my-microvm
{
  description = "NixOS in MicroVMs";

  nixConfig = {
    extra-substituters = [ "https://microvm.cachix.org" ];
    extra-trusted-public-keys = [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  inputs.microvm = {
    url = "github:astro/microvm.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, microvm }:
    let
      system = "x86_64-linux";
    in {
      packages.${system} = {
        default = self.packages.${system}.my-microvm;
        my-microvm = self.nixosConfigurations.my-microvm.config.microvm.declaredRunner;
      };

      nixosConfigurations = {
        my-microvm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            microvm.nixosModules.microvm
            {
              networking.hostName = "my-microvm";


  # A default user able to use sudo
  users.users = {
    root.password = "";
    guest = {
      isNormalUser = true;
      home = "/home/guest";
      extraGroups = [ "wheel" ];
      initialPassword = "westie";
      # packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
      # packages = with pkgs; [
      #   firefox
      #   # thunderbird
      #   ];
      openssh.authorizedKeys.keys = [
          # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
        ];
    };

    alice = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "westie";
    };

    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "westie";
    };
  };

security.sudo.wheelNeedsPassword = false;

              # Set your time zone.
              time.timeZone = "America/Los_Angeles";
              microvm = {
                volumes = [ {
                  mountPoint = "/var";
                  image = "var.img";
                  size = 256;
                } ];
                shares = [ {
                  # use proto = "virtiofs" for MicroVMs that are started by systemd
                  proto = "9p";
                  tag = "ro-store";
                  # a host's /nix/store will be picked up so that no
                  # squashfs/erofs will be built for it.
                  source = "/nix/store";
                  mountPoint = "/nix/.ro-store";
                }

                {
                  # use proto = "virtiofs" for MicroVMs that are started by systemd
                  proto = "9p";
                  tag = "projects";
                  # a host's /nix/store will be picked up so that no
                  # squashfs/erofs will be built for it.
                  source = "/mnt/wsl/projects";
                  mountPoint = "/mnt/projects";
                }

                ];

                # "qemu" has 9p built-in!
                hypervisor = "qemu";
                socket = "control.socket";
              };
            }
          ];
        };
      };
    };
}
