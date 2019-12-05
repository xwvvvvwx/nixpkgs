set -ex pipefail

unset PATH
for p in $buildInputs; do
  export PATH=$p/bin${PATH:+:}$PATH
done

tar -xf $src --strip-components=1

bash configure.sh --prefix=$out --host=i686-linux-gnu
bash bootstrap.sh
bash check.sh
bash install.sh
