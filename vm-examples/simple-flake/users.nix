{ config, lib, pkgs, ... }: {
  users.groups.admin = {};
  users.users = {
    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "westie";
      group = "admin";
    };

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

    # security.sudo.wheelNeedsPassword = false;

  };
}
