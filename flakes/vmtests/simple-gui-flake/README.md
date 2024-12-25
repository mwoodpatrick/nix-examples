# [Setting up qemu VM using nix flakes](https://gist.github.com/FlakM/0535b8aa7efec56906c5ab5e32580adf)

[NixOS virtual machines](https://nix.dev/tutorials/nixos/nixos-configuration-on-vm.html)

[Building a service as a VM (for testing)](https://nixos.wiki/wiki/Cheatsheet)

[Linux kernel - nixos,wiki](https://nixos.wiki/wiki/Linux_kernel)

[Running NixOS Guests on QEMU](https://thenegation.com/posts/nixos-on-qemu/)

[WEMU Networking](https://wiki.qemu.org/Documentation/Networking)

nixos-rebuild build-vm --flake .#my-first-gui-vm $ build the guest VM
export QEMU_NET_OPTS="hostfwd=tcp::2221-:22" # enable port forwarding
./result/bin/run-my-first-nixos-gui-vm-vm # launch the VM

ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no admin@localhost -p 2221 # ssh into VM


# QEMU_NET_OPTS

QEMU_NET_OPTS is an environment variable used to configure network options for QEMU virtual machines. It allows you to specify various network settings, such as port forwarding, which can be useful for accessing services running on the virtual machine from the host system.

Forward TCP traffic from port 2221 on the host to port 22 on the guest, allowing SSH access.

1
thenegation.com

2
wiki.qemu.org
