{
t0 = rec {
    x = 2;
    y = x + 6;
    z = y + 100;
};

t1 = let
  x = { a = 1; b = 2; };
in
{
  names = builtins.attrNames x;
};

t2 = 5;
}

