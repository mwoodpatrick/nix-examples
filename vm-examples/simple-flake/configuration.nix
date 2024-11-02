{ config, lib, pkgs, ... }: let ui.enable = true ; in {
# customize kernel version
  # [The Linux Kernel Archives](https://www.kernel.org/)
  # [Linux kernel](https://nixos.wiki/wiki/Linux_kernel)
  # [linuxPackages_custom_tinyconfig_kernel](linuxPackages_custom_tinyconfig_kernel)
  # [linux_6_11](https://search.nixos.org/packages?channel=24.05&from=0&size=50&sort=relevance&type=packages&query=linux_6_11)
  # [linuxKernel.packages.linux_6_11](https://mynixos.com/packages/linuxKernel.packages.linux_6_11)
  # boot.kernelPackages = pkgs.linuxPackages_5_15;
  boot.kernelPackages = pkgs.linuxPackages_6_11;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "westie";
  networking.networkmanager.enable = true;
 
  time.timeZone = "America/Los_Angeles";

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      forwardPorts = [
        { from = "host"; host.port = 8022; guest.port = 22; }
        { from = "host"; host.port = 8080; guest.port = 80; }
      ];

      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = ui.enable;
      diskSize = 50000;
      resolution = { x =1280; y = 1024; };
    };
  
  westie.ui.enable = ui.enable;
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

  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      default = true;
      locations."/" = {
        return = "200 'Hello World!'";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 80 ];
  environment.systemPackages = with pkgs; [
    htop
    vim
    git
    wget
  ];

  programs.dconf.enable=true;

  system.stateVersion = "24.05";
}
