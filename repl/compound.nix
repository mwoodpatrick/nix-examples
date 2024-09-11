# [Compound values](https://releases.nixos.org/nix/nix-2.24.0/manual/language/types.html#compound-values)

{
# Attribute Sets (Set of key = value pairs)

    full_name = { first = "Mark"; last = "Wood-Patrick"; };

# List (Lists are formed by enclosing a whitespace-separated list of values between square brackets)

    my_list = [ "Hello" "World" ];

# Function

    negate = x: !x;

    concat = x: y: x + y;

    double = x: 2 * x;

# default values
# example calls:
#   splat { x = "cat"; }
#   splat { x = "cat"; z = "dog"; }

    splat = { x, y ? "foo", z ? "bar" }: z + y + x;

# An @-pattern provides a means of referring to the whole value being matched:
# example calls:
# splat2 { x = "cat"; z = "dog"; }
# splat2 { x = "cat"; z = "dog"; a = "rabbit";}
# @<name> can be before or after parameter list

    splat2 = args@{ x, y ? "foo", z ? "bar", ... }: z + y + x + ( args.a or "a missing");

}
