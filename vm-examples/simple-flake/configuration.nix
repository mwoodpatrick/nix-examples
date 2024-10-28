{ config, lib, pkgs, ... }: {
  # customize kernel version
  # [Linux kernel](https://nixos.wiki/wiki/Linux_kernel)
  # boot.kernelPackages = pkgs.linuxPackages_5_15;
  boot.kernelPackages = pkgs.linuxPackages_6_11;

  networking.hostName = "westie";
  networking.networkmanager.enable = true;
 
  time.timeZone = "America/Los_Angeles";

  
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = false;
    };
  
    # [virtualisation.sharedDirectories](https://mynixos.com/nixpkgs/option/virtualisation.sharedDirectories)
    # An attributes set of directories that will be shared with the
    # virtual machine using VirtFS (9P filesystem over VirtIO).
    # The attribute name will be used as the 9P mount tag.
    # [qemu-vm.nix](https://spectrum-os.org/git/nixpkgs/tree/nixos/modules/virtualisation/qemu-vm.nix?id=44d95b773b0998d5db577c7a856b4d8af2aeec19)
    # [Incomplete documentation for "build-vm" options (can be used only inside "virtualisation.vmVariant")](https://github.com/NixOS/nixpkgs/issues/196755)
    # [Change virtualization-options for nixos-rebuild build-vm #59219](https://github.com/NixOS/nixpkgs/issues/59219)
    virtualisation.sharedDirectories = {
      westie-share = { source = "/mnt/wsl"; target = "/mnt/wsl"; };
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  environment.systemPackages = with pkgs; [
    htop
    vim
    git
    wget
  ];

  programs.dconf.enable=true;

  system.stateVersion = "24.05";
}
