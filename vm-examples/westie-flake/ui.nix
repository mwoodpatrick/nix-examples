# [Desktop environment](https://wiki.nixos.org/wiki/Category:Desktop_environment)
# [Checking Whether the Display Server Is Xorg or Wayland](https://www.baeldung.com/linux/display-server-xorg-wayland)
# echo $XDG_SESSION_TYPE
#   x11
#
# echo $DESKTOP_SESSION
#   mate
#
# [The 10 Best Linux Desktop Environments](2024 Update)](https://xtom.com/blog/the-10-best-linux-desktop-environments/)
# [services.displayManager](https://mynixos.com/nixpkgs/options/services.displayManager)
# [Checking Whether the Display Server Is Xorg or Wayland](https://www.baeldung.com/linux/display-server-xorg-wayland)
# [Comparison of X Window System desktop environments](https://en.wikipedia.org/wiki/Comparison_of_X_Window_System_desktop_environments)
#
# An X server display manager (XDM) is a crucial component in the X Window System1
# Its main functions include:
#
#    User Authentication: It presents a login screen where users can enter their credentials (username and password) to access the system2
#
#    Session Management: After successful login, it starts a user session, which includes launching the desktop environment or window manager2
#
#    Graphical Interface: It acts as a bridge between the user and the display server, managing the graphical user interface (GUI)2
#
#    Remote Management: It can also manage remote sessions, allowing users to log in to a remote system and start a graphical session1
#
# Common display managers include GDM (GNOME Display Manager), LightDM, and SDDM (Simple Desktop Display Manage
#
# [X display manager](https://en.wikipedia.org/wiki/X_display_manager)
# [What Are Display Managers and How Do They Work?](https://www.baeldung.com/linux/display-managers-explained)
#
# A window manager running on top of the X server. The window manager is a special X client that is 
# allowed to control the placement of windows. It can also “decorate” windows with standard “widgets” 
# (usually these provide actions like window motion, resizing, iconifying, window killing, etc.). 
# ctwm(1) is NetBSD's default window manager.
#
# [How X Window Managers Work, And How To Write One](https://jichu4n.com/posts/how-x-window-managers-work-and-how-to-write-one-part-i/)
#
{
  lib,
  config,
  pkgs,
  westieTheme,
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

    # Enable the X server:
    services.xserver.enable = true;
    # services.displayManager.sessionPackages = [pkgs.mate.mate-session-manager pkgs.budgie-desktop];

    # [nixos/modules/services/x11/display-managers/lightdm-greeters/slick.nix](nixos/modules/services/x11/display-managers/lightdm-greeters/slick.nix)
    # [pkgs/applications/display-managers/lightdm-slick-greeter/default.nix](https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/applications/display-managers/lightdm-slick-greeter/default.nix)
    # [A slick-looking LightDM greeter](https://github.com/linuxmint/slick-greeter)
    # [slick options](https://mynixos.com/search?q=services.xserver.displayManager.lightdm.greeters.slick)
    services.xserver.displayManager.lightdm.greeters.slick = {
        enable = true;
        # Taken from mint-artwork.gschema.override
        # theme = westieTheme;
        theme = { name = "Mint-Y-Aqua"; package = pkgs.mint-themes; };
        iconTheme = { name = "Mint-Y-Sand"; package = pkgs.mint-y-icons; };
        cursorTheme = { name = "Bibata-Modern-Classic"; package = pkgs.mint-cursor-themes; };
        extraConfig = ''
            background=#772953
            background-color=#000077
        '';
      };

#    services.xserver.displayManager.lightdm.greeters.slick = {
#      enable = true;
#      # theme = { name = "Qogir"; package = pkgs.qogir-theme; };
#      # theme = westieTheme;
#      iconTheme = { name = "Qogir"; package = pkgs.qogir-icon-theme; };
#      cursorTheme = { name = "Qogir"; package = pkgs.qogir-icon-theme; };
#    };

    # services.xserver.displayManager.gdm.enable = true;
    # services.xserver.desktopManager.gnome.enable = true;
    # services.xserver.desktopManager.gnome3.enable = true;

    # [services.xserver.windowManager](https://mynixos.com/nixpkgs/options/services.xserver.windowManager)
    # [Setup i3 on NixOS](https://johnduhamel.io/posts/2019-01-29-nixos-i3-setup.html?form=MG0AV3)
    # [services.xserver.windowManager.i3](https://mynixos.com/nixpkgs/options/services.xserver.windowManager.i3)
    services.xserver.windowManager.twm.enable = true; # Whether to enable twm
    services.xserver.windowManager.i3.enable = false; # Whether to enable i3 window manager.

    # services.dbus.packages = with pkgs; [ gnome2.GConf ];
    
    # See environment variable DESKTOP_SESSION for the DE
    # [Select the display manager](https://mynixos.com/nixpkgs/options/services.displayManager):
    # [Pantheon Desktop](https://nixos.org/manual/nixos/stable/#chap-pantheon)
    services.xserver.displayManager.lightdm.enable = true;
    services.displayManager.defaultSession = "mate";
    # [Select the desktop environment](https://mynixos.com/nixpkgs/options/services.xserver.desktopManager):
    # [https://mynixos.com/options/services.xserver.desktopManager](https://mynixos.com/nixpkgs/options/services.xserver.desktopManager)
    # services.xserver.desktopManager.pantheon.enable = true; # Enable the pantheon desktop manager.
    # nixos/modules/services/x11/desktop-managers/plasma5.nix
    services.xserver.desktopManager.plasma5.enable = true; # Enable the Plasma 5 (KDE 5) desktop environment.
    # services.xserver.desktopManager.plasma6.enable = true; # Enable the Plasma 6 (KDE 6) desktop environment.
    # nixos/modules/services/x11/desktop-managers/budgie.nix
    services.xserver.desktopManager.budgie.enable = true; # Enable the Budgie desktop manager.
    # nixos/modules/services/x11/desktop-managers/cinnamon.nix
    services.xserver.desktopManager.cinnamon.enable = true; # Enable the cinnamon desktop manager.
    # error: The option `virtualisation.vmVariant.services.displayManager.defaultSession' has conflicting definition values:
    #   - In `/nix/store/0az17ihialzgdlg2r9jinzmh23dka8qz-source/nixos/modules/services/x11/desktop-managers/deepin.nix': "dde-x11"
    #   - In `/nix/store/0az17ihialzgdlg2r9jinzmh23dka8qz-source/nixos/modules/services/x11/desktop-managers/pantheon.nix': "pantheon"
    #   Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
    # nixos/modules/services/x11/desktop-managers/deepin.nix
    # services.xserver.desktopManager.deepin.enable = true; # Whether to enable Deepin desktop manager.

    # [MATE Desktop Environment](https://mate-desktop.org/)
    # [Desktop entries](https://wiki.archlinux.org/title/Desktop_entries?form=MG0AV3)
    # [services.xserver.desktopManager.mate](https://mynixos.com/nixpkgs/options/services.xserver.desktopManager.mate)
    services.xserver.desktopManager.mate.enable = true; # Enable the MATE desktop environment.
    # services.xserver.desktopManager.xterm.enable = true; # Enable a xterm terminal as a desktop manager

    services.xserver.xkb.layout = "us";

    services.qemuGuest.enable = true;
  
    # Install spice-vdagent to enable copy and paste between host and guest
    services.spice-vdagentd.enable = true;  
    # mkSure sets the priority of the attribute very high so that it will override any 
    # values set by other services or settings in nixpkgs.
    # [Setting Priorities](https://nixos.org/manual/nixos/stable/#sec-option-definitions-setting-priorities)
    # services.spice-vdagentd.enable = mkSure true;

    #[Help! I cant have Pantheon, Gnome and Plasma installed on my system at the same time - Help - NixOS Discourse](https://discourse.nixos.org/t/help-i-cant-have-pantheon-gnome-and-plasma-installed-on-my-system-at-the-same-time/47346/4)
    environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR =
    let
      cfg = config.services.xserver.desktopManager.gnome;
      nixos-background-light = pkgs.nixos-artwork.wallpapers.simple-blue;
      nixos-background-dark = pkgs.nixos-artwork.wallpapers.simple-dark-gray;
      flashbackEnabled = cfg.flashback.enableMetacity || lib.length cfg.flashback.customSessions > 0;
      nixos-gsettings-desktop-schemas = pkgs.gnome.nixos-gsettings-overrides.override {
        inherit (cfg) extraGSettingsOverrides extraGSettingsOverridePackages favoriteAppsOverride;
        inherit flashbackEnabled nixos-background-dark nixos-background-light;
      };
    in
    lib.mkForce (pkgs.glib.getSchemaPath nixos-gsettings-desktop-schemas);


    environment.systemPackages = with pkgs; [
      # https://nixos.wiki/wiki/Vim
      # gvim
      # https://nixos.wiki/wiki/Firefox
      firefox-unwrapped
      xorg.xdpyinfo
    ];
  };
}
