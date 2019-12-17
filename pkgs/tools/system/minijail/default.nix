{ stdenv, fetchgit, libcap }:

stdenv.mkDerivation rec {
  pname = "minijail";
  version = "android-10.0.0_r9";

  src = fetchgit {
    url = "https://android.googlesource.com/platform/external/minijail";
    rev = version;
    sha256 = "0gcfsyim1krrddcklydqfxl8mamaxgail2xl5qp9yclq60km8f22";
  };

  buildInputs = [ libcap ];

  makeFlags = [ "LIBDIR=$(out)/lib" ];

  preConfigure = ''
    substituteInPlace common.mk --replace /bin/echo echo
    sed -i '/#include <asm\/siginfo.h>/ d' signal_handler.c
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -v *.so $out/lib
    mkdir -p $out/include
    cp -v libminijail.h $out/include
    mkdir -p $out/bin
    cp minijail0 $out/bin
  '';

  meta = {
    homepage = https://android.googlesource.com/platform/external/minijail/;
    description = "Sandboxing library and application using Linux namespaces and capabilities";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [pcarrier];
    platforms = stdenv.lib.platforms.linux;
  };
}
