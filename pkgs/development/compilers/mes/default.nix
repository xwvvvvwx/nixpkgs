{ strace, stdenv32, patch, bash, fetchurl, coreutils, gnused, gnutar, gnugrep, guile, guile-nyacc, gzip, mescc-tools }:

  /*
    The build has four phases:

    1. build mes using the gcc in stdenv
    2. build mescc using the mes from step 1
    3. build mes using the mescc from step 2
    4. build mescc using the mes from step 3

    This lets us abstract the original toolchain away, and allows us produce
    mes and mescc binaries that are bit for bit identical to those built
    using seperate toolchains in other distros.

    This is a technique known as diverse double compilation, and it lets us
    provide strong guarantees that the mes and mescc are provided here are free
    from trusting-trust style attacks.

    NB. The final compilation step (4) is not strictly nescessary, and is
    performmed only because it allows for a simpiler package expression
  */

let
  pname = "mes";
  version = "0.21";

  src = fetchurl {
    url = "mirror://savannah/mes/mes-${version}.tar.gz";
    sha256 = "104qxngxyl7pql8vqrnli3wfyx0ayfaqg8gjfhmk4qzrafs46slm";
  };

  #src = fetchurl {
    #url = "http://lilypond.org/janneke/mes/mes-0.21-11-gd8f361705.tar.gz";
    #sha256 = "0j40xr39vjwzzq9rj28s2y25jlyghradh84l65fmawxfv7vsmpy8";
  #};

  mes-stage1 = stdenv32.mkDerivation {
    pname = "mes-stage1";
    inherit version src;
    #patches = [ ./patch.patch ];
    buildInputs = [ guile guile-nyacc mescc-tools ];
    hardeningDisable = [ "all" ]; # TODO: get more granular here
  };
in

derivation {
  inherit src pname version;
  name = "${pname}-${version}";
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];

  AR = "${mes-stage1}/bin/mesar";
  CC = "${mes-stage1}/bin/mescc";
  GUILE_LOAD_PATH = "${guile-nyacc}/share/guile/site/2.2";
  MES_PREFIX = "${mes-stage1}/share/mes";

  MES_ARENA = "100000000";
  MES_MAX_ARENA = "100000000";
  MES_STACK = "10000000";

  buildInputs = [
    bash
    coreutils
    patch
    gnugrep
    gnused
    gnutar
    gzip
    mes-stage1
    mescc-tools
    strace
  ];
  system = "i686-linux";
}
