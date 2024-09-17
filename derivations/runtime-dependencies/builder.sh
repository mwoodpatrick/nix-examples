set -e
unset PATH
for p in $buildInputs $baseInputs; do
    export PATH=$p/bin${PATH:+:}$PATH
done

tar -xf $src

for d in *; do
    if [ -d "$d" ]; then
        cd "$d"
        break
    fi
done

./configure --prefix=$out
make
make install
echo find $out -type f -exec patchelf --shrink-rpath '{}' \; -exec strip '{}'
find $out -type f -exec patchelf --shrink-rpath '{}' \; -exec strip '{}' \; 2>/dev/null
echo "all done status=$?!"
