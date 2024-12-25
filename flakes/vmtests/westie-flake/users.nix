{ inputs, lib, config, options, pkgs, ... } : {

  # requires --impure
  # imports = [ <home-manager/nixos> ];
  # [User Management](https://nlewo.github.io/nixos-manual-sphinx/configuration/user-mgmt.xml.html)
  # [users.users.<name>](https://mynixos.com/options/users.users.%3Cname%3E)

  users.groups.admin = {};
  users.users = {
    mwoodpatrick = {
      description = "Mark L. Wood-Patrick";
      isNormalUser = true;
      uid = 1000;
      group = "users";
      extraGroups = [ "wheel" "libvirt" "admin" ];
      initialPassword = "westie";
      packages = [ pkgs.cowsay ]; # echo "hello world" | cowsay

      # ssh-keygen  -C "My key for mwoodpatrick.org" -t ed25519
      openssh.authorizedKeys = {
        # keys = [
        #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJP4QptwY8hbADKK9esL1gU53gWRImyk9Y7s3vNjReT"
        #  ];
        # error: access to absolute path '/.ssh' is forbidden in pure evaluation mode (use '--impure' to override)
        # [users.users.<name>.openssh.authorizedKeys.keyFiles](https://mynixos.com/nix-darwin/option/users.users.%3Cname%3E.openssh.authorizedKeys.keyFiles)
        # keyFiles requires a local path specification
        # cp ~/.ssh/id_ed25519.pub .
        keyFiles = [ ./id_ed25519.pub ];
      };
    };

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

    # security.sudo.wheelNeedsPassword = false;

  };
}
