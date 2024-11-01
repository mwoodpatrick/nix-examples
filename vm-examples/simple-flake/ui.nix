# [Desktop environment](https://wiki.nixos.org/wiki/Category:Desktop_environment)
# [The 10 Best Linux Desktop Environments (2024 Update)](https://xtom.com/blog/the-10-best-linux-desktop-environments/)
# [services.displayManager](https://mynixos.com/nixpkgs/options/services.displayManager)
{
  lib,
  config,
  pkgs,
  ...
}: let cfg = config.westie.ui; in {
  imports = [
    # (import ./special-fonts-1.nix {inherit config pkgs;}) # (1)
    # ./special-fonts-2.nix # (2)
  ];

  options = {
    westie.ui.enable = lib.mkEnableOption "Enable Module";
  };

  config = lib.mkIf cfg.enable {
    #config contents
    # fontconfig.enable = true;
    services.xserver.enable = true;
    # services.xserver.displayManager.gdm.enable = true;
    # services.xserver.desktopManager.gnome.enable = true;
    # services.xserver.desktopManager.gnome3.enable = true;

    # services.dbus.packages = with pkgs; [ gnome2.GConf ];
    
    # [Pantheon Desktop](https://nixos.org/manual/nixos/stable/#chap-pantheon)
    services.xserver.displayManager.lightdm.enable = true;


    # [](https://mynixos.com/nixpkgs/options/services.xserver.desktopManager)
    # services.xserver.desktopManager.pantheon.enable = true;
    # services.xserver.desktopManager.plasma5.enable = true;
    # services.xserver.desktopManager.budgie.enable = true;
    # services.xserver.desktopManager.cinnamon.enable = true;
    services.xserver.desktopManager.mate.enable = true;

    services.qemuGuest.enable = true;
  
    # Install spice-vdagent to enable copy and paste between host and guest
    services.spice-vdagentd.enable = true;  
    # mkSure sets the priority of the attribute very high so that it will override any 
    # values set by other services or settings in nixpkgs.
    # [Setting Priorities](https://nixos.org/manual/nixos/stable/#sec-option-definitions-setting-priorities)
    # services.spice-vdagentd.enable = mkSure true;

    environment.systemPackages = with pkgs; [
      # https://nixos.wiki/wiki/Vim
      # gvim
      # https://nixos.wiki/wiki/Firefox
      firefox-unwrapped
    ];
  };
}
