{ stdenv, fetchgit, libvirt, autoconf, automake, ocaml, findlib, perl, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ocaml-libvirt";
  rev = "09a2b4143099badc3747f686611079d718e6d33a";
  version = "v0.6.1.5";

  src = fetchgit {
    url = "git://libvirt.org/libvirt-ocaml.git";
    rev = rev;
    sha256 = "0xpkdmknk74yqxgw8z2w8b7ss8hpx92xnab5fsqg2byyj55gzf2k";
  };

  propagatedBuildInputs = [ libvirt ];

  nativeBuildInputs = [ autoconf findlib automake perl pkgconfig ];

  buildInputs = [ ocaml ];

  createFindlibDestdir = true;

  preConfigure = ''
    aclocal
    autoheader
    autoconf
  '';

  buildPhase = if stdenv.cc.isClang then "make all opt CPPFLAGS=-Wno-error" else "make all opt";

  installPhase = "make install-opt";

  meta = with stdenv.lib; {
    description = "OCaml bindings for libvirt";
    homepage = https://libvirt.org/ocaml/;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = ocaml.meta.platforms or [];
  };
}
