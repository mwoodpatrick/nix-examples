{ config, lib, pkgs, ... }: {
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

  time.timeZone = "America/Los_Angeles";

  users.groups.admin = {};
  users.users = {
    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "westie";
      group = "admin";
    };

    alice = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        initialPassword = "westie";
    };
  };

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
    };
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;

  services.dbus.packages = with pkgs; [ gnome2.GConf ];

  services.qemuGuest.enable = true;
  
  # Install spice-vdagent to enable copy and paste between host and guest
  services.spice-vdagentd.enable = true;  
  # mkSure sets the priority of the attribute very high so that it will override any 
  # values set by other services or settings in nixpkgs.
  # [Setting Priorities](https://nixos.org/manual/nixos/stable/#sec-option-definitions-setting-priorities)
  # services.spice-vdagentd.enable = mkSure true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.hostName = "my-first-nixos-gui";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  environment.systemPackages = with pkgs; [
    htop
    vim
    git
    wget
  ];

  system.stateVersion = "24.05";
}
