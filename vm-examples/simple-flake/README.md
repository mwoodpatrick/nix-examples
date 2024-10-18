# [Setting up qemu VM using nix flakes](https://gist.github.com/FlakM/0535b8aa7efec56906c5ab5e32580adf)

[Linux kernel - nixos,wiki](https://nixos.wiki/wiki/Linux_kernel)

nixos-rebuild build-vm --flake .#test
result/bin/run-my-nixos-system-vm

ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no admin@localhost -p 2221
