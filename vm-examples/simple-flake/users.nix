{ inputs, lib, config, options, pkgs, ... } : {

  # requires --impure
  # imports = [ <home-manager/nixos> ];

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
      packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
      # packages = with pkgs; [
      #   firefox
      #   # thunderbird
      #   ];
      openssh.authorizedKeys.keys = [
          # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
        ];
    };

    mwoodpatrick = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "westie";
      packages = [ pkgs.cowsay ]; # echo "hello world" | cowsay
    };

    # security.sudo.wheelNeedsPassword = false;

  };
}
