{ stdenv, fetchurl, pkgconfig, guile, guile-lib }:
stdenv.mkDerivation rec {
  pname = "nyacc";
  version = "0.99.0";

  GUILE_AUTO_COMPILE = 0;
  nativeBuildInputs = [ pkgconfig guile ];

  src = fetchurl {
    url = "mirror://savannah/nyacc/nyacc-${version}.tar.gz";
    sha256 = "0hl5qxx19i4x1r0839sxm19ziqq65g4hy97yik81cc2yb9yvgyv3";
  };

  # stop nyacc from writing into the guile store path
  patchPhase = ''
    makefiles=$(find . -name "Makefile.in")

    sed -i 's:INFODIR = @GUILE_DATADIR@/info:INFODIR = @prefix@/share/info:' $makefiles
    sed -i 's:DOCDIR = @GUILE_DATADIR@/doc/$(PACKAGE_TARNAME):DOCDIR = @prefix@/share/doc/$(PACKAGE_TARNAME):' $makefiles
    sed -i 's:SITE_SCM_DIR = @GUILE_SITE@:SITE_SCM_DIR = @prefix@/share/guile/site/@GUILE_EFFECTIVE_VERSION@:' $makefiles
    sed -i 's:SITE_SCM_GO_DIR = @GUILE_SITE_GO@:SITE_SCM_GO_DIR = @prefix@/lib/guile/@GUILE_EFFECTIVE_VERSION@/site-ccache:' $makefiles
  '';
}
