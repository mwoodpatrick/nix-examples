rec {
#   [Simple/primitive types](https://releases.nixos.org/nix/nix-2.24.0/manual/language/types.html#primitives)

# Integer (signed 64-bit integer)

    one = 1;
    two = 2;
    three = one + two;
    six   = two * three;
    seven = one + six;

# Float (64-bit IEEE 754 floating-point number)

    pi = 3.14159263;

# Boolean (A boolean in the Nix language is one of true or false)

    no = false;
    yes = true;

# String (A string in the Nix language is an immutable, finite-length sequence of bytes, along with a string context. Nix does not assume or support working natively with character encodings.)

    name = "Mark";
    greeting = "Hello ${name} have a nice day";

# Path (A path in the Nix language is an immutable, finite-length sequence of bytes starting with /, representing a POSIX-style, canonical file system path.)

    path = /usr/local/bin;
    home = /home/${name};

# Null (There is a single value of type null in the Nix language.)

    none = builtins.null;
# 
}
