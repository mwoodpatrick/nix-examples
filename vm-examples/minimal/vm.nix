# Build this VM with nix build  ./#nixosConfigurations.vm.config.system.build.vm
# Then run is with: ./result/bin/run-nixos-vm
# To be able to connect with ssh enable port forwarding with:
# QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-nixos-vm
# Then connect with ssh -p 2222 guest@localhost
{ inputs, lib, config, pkgs, ... }:
{
  # nix.nixPath = [ "nixpkgs=/home/matt/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Internationalisation options
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  networking.hostName = "minimal"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Options for the screen
  virtualisation.vmVariant = {
    virtualisation.resolution = {
      x = 1280;
      y = 1024;
    };
    virtualisation.qemu.options = [
      # Better display option
      "-vga virtio"
      "-display gtk,zoom-to-fit=false"
      # Enable copy/paste
      # https://www.kraxel.org/blog/2021/05/qemu-cut-paste/
      "-chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on"
      "-device virtio-serial-pci"
      "-device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0"
    ];
  };

  # A default user able to use sudo
  users.users.guest = {
    isNormalUser = true;
    home = "/home/guest";
    extraGroups = [ "wheel" ];
    initialPassword = "guest";
    packages = with pkgs; [
        firefox
        # thunderbird
        ];
  };

  security.sudo.wheelNeedsPassword = false;

  # X configuration
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";

  services.displayManager.autoLogin.user = "guest";
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.enableScreensaver = false;

  services.xserver.videoDrivers = [ "qxl" ];

  # For copy/paste to work
  services.spice-vdagentd.enable = true;

  # Enable ssh
  services.sshd.enable = true;

  # Included packages in system profile here
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    dig
    fzf
    git
    glances
    hey
    htop
    httpie
    google-chrome
    neovim
    neofetch
    tmux
    wget
    wrk
  ];

  system.stateVersion = "24.05";
}
