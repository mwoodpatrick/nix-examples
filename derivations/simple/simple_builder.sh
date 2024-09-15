export PATH="$coreutils/bin:$gcc/bin"
declare -xp
mkdir $out
gcc -o $out/simple $src
