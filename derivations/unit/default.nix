# [NGINX Unit - Universal web app server (Website)](https://unit.nginx.org/)
# [NGINX Unit - Universal web app server (GitHub)](https://github.com/nginx/unit)
# [pkgs/servers/http/unit](https://github.com/NixOS/nixpkgs/tree/nixos-24.05/pkgs/servers/http/unit)
#
# d = import ./build.nix
#
# nix-repl> d
# «derivation /nix/store/mh75smhjriilzvpkz7pvgcyr72i2v3pl-myunit-1.33.0.drv»
#
# Determine derivation used to build unitd:
#
#   nix-instantiate build.nix
#       warning: you did not specify '--add-root'; the result might be removed by the garbage collector
#       /nix/store/3nrjvx5g3qgwgmvvk099bdjc5wqf95yg-myunit-1.33.0.drv
#
# View the derivation:
#
#    nix derivation show /nix/store/3nrjvx5g3qgwgmvvk099bdjc5wqf95yg-myunit-1.33.0.drv 
#
# Get the dependencies of unitd
#
#   nix-store -q --references $(nix-instantiate build.nix)
#     warning: you did not specify '--add-root'; the result might be removed by the garbage collector
#     /nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh
#     /nix/store/9lia9mm7lxbpr66rh94qpkard1mhc4s7-bash-5.2p32.drv
#     /nix/store/ds0ivhwwyrcim9b0i8gfvb7sqnimyqz8-pcre2-10.43.drv
#     /nix/store/dbvdpqyhcs21vxnhhzg8r6jh076lxzja-stdenv-linux.drv
#     /nix/store/lng4mp7lya4qaz5826i4lry4n20jpj3w-php-8.2.23.drv
#     /nix/store/0c1p91a4paka1rnj6z9jwgzspaabmng2-php-with-extensions-8.2.23.drv
#     /nix/store/1s0hcy0yg9ai733vagx6p0b9x5s9sd3x-which-2.21.drv
#     /nix/store/nv9544xr5m4is9gmrbsjhgkb22c43v8f-perl-5.38.2.drv
#     /nix/store/ff2brvj5iqqbc95gdh1lipy8jx3q7fbd-openssl-3.0.14.drv
#     /nix/store/l9yap7kmz22bvhb5b7f6q0p8cjklgmmn-ncurses-6.4.drv
#     /nix/store/n8grbnvx72h02w9rxp5bsnhygi991k9f-ruby-3.2.4.drv
#     /nix/store/pfnwpfn4r5hvc8xlb7hfy5jzqs1111dn-python3-3.11.9.drv
#     /nix/store/sf7j6dd8scnv7cp8z2ryfim65xws9mry-source.drv
#
# THe runtime dependencies for each executable and shared library are specified in the [rpath](https://en.wikipedia.org/wiki/Rpath].
# Nix uses a tool called [patchelf](https://github.com/NixOS/patchelf], to reduces the rpath 
# to the paths that are actually used by the binary.
#
#	find $out -type f -exec patchelf --shrink-rpath '{}' \; -exec strip '{}' \; 2>/dev/null
#
#
# Build unitd:
#
#   nix-build build.nix
#
# Get version of unitd:
#
#   ./result/bin/unitd --version
#


let
    nixpkgs = ( import <nixpkgs> ) {}; unit = import ./build-unit.nix;
in 
    unit { lib = nixpkgs.lib; stdenv = nixpkgs.pkgs.stdenv ; fetchFromGitHub = nixpkgs.pkgs.fetchFromGitHub;
       nixosTests = nixpkgs.pkgs.nixosTests ; which = nixpkgs.pkgs.which; pcre2 = nixpkgs.pkgs.pcre2; 
       python3 = nixpkgs.pkgs.python3 ; ncurses = nixpkgs.pkgs.ncurses; 
       withPHP81 = false; php81 = nixpkgs.pkgs.php81;
       withPHP82 = true ; php82 = nixpkgs.pkgs.php82; 
       perl536 = nixpkgs.pkgs.perl536; 
       perl538 = nixpkgs.pkgs.perl538;
       withRuby_3_1 = false; ruby_3_1 = nixpkgs.pkgs.ruby_3_1;
       withRuby_3_2 = true; ruby_3_2 = nixpkgs.pkgs.ruby_3_2;
       openssl = nixpkgs.pkgs.openssl;
       }




