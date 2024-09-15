# [Nix Pills](https://nixos.org/guides/nix-pills/00-preface)

rec {
# Nix expressions


a = 3;
b = 4;

# If expressions
c = if a > b then "yes" else "no";

# Let expressions
l = let a = "foo"; in a ;

# With expression
longName = { a = 3; b = 4; };

e = longName.a + longName.b;
w = with longName; a + b;

# More than one parameter

mul = a: (b: a*b);

# default arguments
mul2 = { a, b ? 2 }: a*b;

g = mul2 { a = 9; };

h = mul2 { a=9; b=4; };

# variadic arguments

mul3 = s@{ a, b, ... }: a*b*s.c;
v = mul3 { a = 3; b = 4; c = 2; };

mul4 = { a, b, ... }@s: a*b*s.c;
z = mul4 { a = 3; b = 4; c = 2; };

# imports

ia = import ./a.nix;
ib = import ./b.nix;
imul = import ./mul.nix;
ires = imul a b;

# imprt function and provide args

ifnc = import ./test.nix { a = 5; trueMsg = "ok"; };
}
