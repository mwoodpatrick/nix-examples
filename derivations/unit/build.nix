# d = import ./build.nix
#
# nix-repl> d
# «derivation /nix/store/mh75smhjriilzvpkz7pvgcyr72i2v3pl-myunit-1.33.0.drv»

let
    nixpkgs = ( import <nixpkgs> ) {}; unit = import ./default.nix;
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




