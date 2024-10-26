{ config, lib, pkgs, ... }: {
  # customize kernel version
  # [Linux kernel](https://nixos.wiki/wiki/Linux_kernel)
  # boot.kernelPackages = pkgs.linuxPackages_5_15;
  boot.kernelPackages = pkgs.linuxPackages_6_11;

  networking.hostName = "westie";
  networking.networkmanager.enable = true;
 
  time.timeZone = "America/Los_Angeles";
  
  users.groups.admin = {};
  users.users = {
    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "admin";
      group = "admin";
    };
  };

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = false;
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

  system.stateVersion = "24.05";
}
