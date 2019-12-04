set -ex pipefail

unset PATH
for p in $buildInputs; do
  export PATH=$p/bin${PATH:+:}$PATH
done

tar -xf $src --strip-components=1

bash configure.sh --prefix=$out --host=$system-gnu
bash bootstrap.sh
bash install.sh
bash check.sh
