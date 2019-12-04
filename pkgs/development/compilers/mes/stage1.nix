{ stdenv, lib, fetchurl, guile, mescc-tools, guile-nyacc }:
stdenv.mkDerivation rec {
  pname = "mes";
  version = "0.21";
  buildInputs = [ guile guile-nyacc mescc-tools ];
  hardeningDisable = [ "all" ]; # TODO: get more granular here
  src = fetchurl {
    url = "mirror://savannah/mes/mes-${version}.tar.gz";
    sha256 = "104qxngxyl7pql8vqrnli3wfyx0ayfaqg8gjfhmk4qzrafs46slm";
  };
}
