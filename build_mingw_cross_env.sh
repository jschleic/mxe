#!/bin/bash
set -e


#---
#   Build a MinGW cross compiling environment
#
#   Version:        -alpha-
#   Homepage:       http://www.profv.de/mingw_cross_env/
#   File name:      build_mingw_cross_env.sh
#   Project start:  2007-06-12
#
#   This script compiles a MinGW cross compiler and cross compiles
#   many free libraries such as GD and SDL. Thus, it provides you
#   a nice MinGW cross compiling environment. All necessary source
#   packages are downloaded automatically.
#---


#---
#   Copyright (c)  Volker Grabsch <vog@notjusthosting.com>
#
#   Permission is hereby granted, free of charge, to any person obtaining
#   a copy of this software and associated documentation files (the
#   "Software"), to deal in the Software without restriction, including
#   without limitation the rights to use, copy, modify, merge, publish,
#   distribute, sublicense, and/or sell copies of the Software, and to
#   permit persons to whom the Software is furnished to do so, subject
#   to the following conditions:
#
#   The above copyright notice and this permission notice shall be
#   included in all copies or substantial portions of the Software.
# 
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#---


#---
#   Configuration
#---

TARGET="i386-mingw32msvc"
BUILD=`gcc -dumpmachine`
ROOT=`pwd`
PREFIX="$ROOT/usr"
SOURCE="$ROOT/src"
DOWNLOAD="$ROOT/download"

PATH="$PREFIX/bin:$PATH"

VERSION_mingw_runtime=3.9
VERSION_w32api=3.7
VERSION_binutils=2.17.50-20060824-1
VERSION_gcc=3.4.5-20060117-1
VERSION_pkg_config=0.21
VERSION_pthreads=2-8-0
VERSION_zlib=1.2.3
VERSION_libxml2=2.6.29
VERSION_libgpg_error=1.5
VERSION_libgcrypt=1.2.4
VERSION_gnutls=1.6.3
VERSION_curl=7.16.2
VERSION_libpng=1.2.18
VERSION_jpeg=6b
VERSION_tiff=3.8.2
VERSION_giflib=4.1.4
VERSION_freetype=2.3.4
VERSION_fontconfig=2.4.2
VERSION_gd=2.0.35RC4
VERSION_SDL=1.2.11
VERSION_smpeg=0.4.5+cvs20030824
VERSION_SDL_mixer=1.2.7
VERSION_geos=3.0.0rc4
VERSION_proj=4.5.0
VERSION_libgeotiff=1.2.3
VERSION_gdal=1.4.1


#---
#   Main
#---

case "$1" in
"")
    echo "Stage 1: $BASH '$0' --download"
    $BASH "$0" --download
    echo "Stage 2: $BASH '$0' --build"
    $BASH "$0" --build
    exit 0
    ;;
--download)
    # go ahead
    ;;
--build)
    # go ahead
    ;;
*)
    echo "Usage: $0 [ --download | --build ]"
    exit 1
    ;;
esac


#---
#   Prepare
#---

case "$1" in

--download)
    mkdir -p "$DOWNLOAD"
    ;;

--build)
    rm -rfv "$PREFIX"
    rm -rfv "$SOURCE"
    mkdir -p "$PREFIX"
    mkdir -p "$SOURCE"
    ;;

esac


#---
#   MinGW Runtime
#
#   http://mingw.sourceforge.net/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "mingw-runtime-$VERSION_mingw_runtime.tar.gz" &>/dev/null ||
    wget -c "http://downloads.sourceforge.net/mingw/mingw-runtime-$VERSION_mingw_runtime.tar.gz"
    ;;

--build)
    install -d "$PREFIX/$TARGET"
    cd "$PREFIX/$TARGET"
    tar xfvz "$DOWNLOAD/mingw-runtime-$VERSION_mingw_runtime.tar.gz"
    ;;

esac


#---
#   MinGW Windows API
#
#   http://mingw.sourceforge.net/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "w32api-$VERSION_w32api.tar.gz" &>/dev/null ||
    wget -c "http://downloads.sourceforge.net/mingw/w32api-$VERSION_w32api.tar.gz"
    ;;

--build)
    install -d "$PREFIX/$TARGET"
    cd "$PREFIX/$TARGET"
    tar xfvz "$DOWNLOAD/w32api-$VERSION_w32api.tar.gz"
    ;;

esac


#---
#   MinGW binutils
#
#   http://mingw.sourceforge.net/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "binutils-$VERSION_binutils-src.tar.gz" &>/dev/null ||
    wget -c "http://downloads.sourceforge.net/mingw/binutils-$VERSION_binutils-src.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/binutils-$VERSION_binutils-src.tar.gz"
    cd "binutils-$VERSION_binutils-src"
    ./configure \
        --target="$TARGET" \
        --prefix="$PREFIX" \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared
    make
    make install
    strip -sv \
        "$PREFIX/bin/$TARGET-addr2line" \
        "$PREFIX/bin/$TARGET-ar" \
        "$PREFIX/bin/$TARGET-as" \
        "$PREFIX/bin/$TARGET-c++filt" \
        "$PREFIX/bin/$TARGET-dlltool" \
        "$PREFIX/bin/$TARGET-dllwrap" \
        "$PREFIX/bin/$TARGET-gprof" \
        "$PREFIX/bin/$TARGET-ld" \
        "$PREFIX/bin/$TARGET-nm" \
        "$PREFIX/bin/$TARGET-objcopy" \
        "$PREFIX/bin/$TARGET-objdump" \
        "$PREFIX/bin/$TARGET-ranlib" \
        "$PREFIX/bin/$TARGET-readelf" \
        "$PREFIX/bin/$TARGET-size" \
        "$PREFIX/bin/$TARGET-strings" \
        "$PREFIX/bin/$TARGET-strip" \
        "$PREFIX/bin/$TARGET-windres" \
        "$PREFIX/$TARGET/bin/ar" \
        "$PREFIX/$TARGET/bin/as" \
        "$PREFIX/$TARGET/bin/dlltool" \
        "$PREFIX/$TARGET/bin/ld" \
        "$PREFIX/$TARGET/bin/nm" \
        "$PREFIX/$TARGET/bin/objdump" \
        "$PREFIX/$TARGET/bin/ranlib" \
        "$PREFIX/$TARGET/bin/strip" \
        "$PREFIX/lib/libiberty.a"
    ;;

esac


#---
#   MinGW GCC
#
#   http://mingw.sourceforge.net/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "gcc-core-$VERSION_gcc-src.tar.gz" &>/dev/null ||
    wget -c "http://downloads.sourceforge.net/mingw/gcc-core-$VERSION_gcc-src.tar.gz"
    tar tfz "gcc-g++-$VERSION_gcc-src.tar.gz" &>/dev/null ||
    wget -c "http://downloads.sourceforge.net/mingw/gcc-g++-$VERSION_gcc-src.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/gcc-core-$VERSION_gcc-src.tar.gz"
    tar xfvz "$DOWNLOAD/gcc-g++-$VERSION_gcc-src.tar.gz"
    cd "gcc-$VERSION_gcc"
    ./configure \
        --target="$TARGET" \
        --prefix="$PREFIX" \
        --enable-languages="c,c++" \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared \
        --without-x \
        --enable-threads=win32 \
        --disable-win32-registry \
        --enable-sjlj-exceptions
    make
    make install
    VERSION_gcc_short=`echo "$VERSION_gcc" | cut -d'-' -f1`
    strip -sv \
        "$PREFIX/bin/$TARGET-c++" \
        "$PREFIX/bin/$TARGET-cpp" \
        "$PREFIX/bin/$TARGET-g++" \
        "$PREFIX/bin/$TARGET-gcc" \
        "$PREFIX/bin/$TARGET-gcc-3.4.5" \
        "$PREFIX/bin/$TARGET-gcov" \
        "$PREFIX/$TARGET/bin/c++" \
        "$PREFIX/$TARGET/bin/g++" \
        "$PREFIX/$TARGET/bin/gcc" \
        "$PREFIX/libexec/gcc/$TARGET/$VERSION_gcc_short/cc1" \
        "$PREFIX/libexec/gcc/$TARGET/$VERSION_gcc_short/cc1plus" \
        "$PREFIX/libexec/gcc/$TARGET/$VERSION_gcc_short/collect2"
    ;;

esac


#---
#   pkg-config
#
#   http://pkg-config.freedesktop.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "pkg-config-$VERSION_pkg_config.tar.gz" &>/dev/null ||
    wget -c "http://pkgconfig.freedesktop.org/releases/pkg-config-$VERSION_pkg_config.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/pkg-config-$VERSION_pkg_config.tar.gz"
    cd "pkg-config-$VERSION_pkg_config"
    ./configure --prefix="$PREFIX/$TARGET"
    make install
    install -d "$PREFIX/bin"
    rm -fv "$PREFIX/bin/$TARGET-pkg-config"
    ln -s "../$TARGET/bin/pkg-config" "$PREFIX/bin/$TARGET-pkg-config"
    ;;

esac


#---
#   pthreads-w32
#
#   http://sourceware.org/pthreads-win32/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "pthreads-w32-$VERSION_pthreads-release.tar.gz" &>/dev/null ||
    wget -c "ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-$VERSION_pthreads-release.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/pthreads-w32-$VERSION_pthreads-release.tar.gz"
    cd "pthreads-w32-$VERSION_pthreads-release"
    sed '35i\#define PTW32_STATIC_LIB' -i pthread.h
    make CROSS="$TARGET-" GC-static
    install -d "$PREFIX/$TARGET/lib"
    install -m664 libpthreadGC2.a "$PREFIX/$TARGET/lib/libpthread.a"
    install -d "$PREFIX/$TARGET/include"
    install -m664 pthread.h sched.h semaphore.h "$PREFIX/$TARGET/include/"
    ;;

esac


#---
#   zlib
#
#   http://www.zlib.net/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "zlib-$VERSION_zlib.tar.bz2" &>/dev/null ||
    wget -c "http://downloads.sourceforge.net/libpng/zlib-$VERSION_zlib.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/zlib-$VERSION_zlib.tar.bz2"
    cd "zlib-$VERSION_zlib"
    CC="$TARGET-gcc" RANLIB="$TARGET-ranlib" ./configure \
        --prefix="$PREFIX/$TARGET"
    make install
    ;;

esac


#---
#   libxml2
#
#   http://www.xmlsoft.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "libxml2-$VERSION_libxml2.tar.gz" &>/dev/null ||
    wget -c "ftp://xmlsoft.org/libxml2/libxml2-$VERSION_libxml2.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/libxml2-$VERSION_libxml2.tar.gz"
    cd "libxml2-$VERSION_libxml2"
    sed 's,`uname`,MinGW,g' -i xml2-config.in
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --without-debug \
        --prefix="$PREFIX/$TARGET" \
        --without-python
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   libgpg-error
#
#   ftp://ftp.gnupg.org/gcrypt/libgpg-error/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "libgpg-error-$VERSION_libgpg_error.tar.bz2" &>/dev/null ||
    wget -c "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-$VERSION_libgpg_error.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/libgpg-error-$VERSION_libgpg_error.tar.bz2"
    cd "libgpg-error-$VERSION_libgpg_error"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   libgcrypt
#
#   ftp://ftp.gnupg.org/gcrypt/libgcrypt/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "libgcrypt-$VERSION_libgcrypt.tar.bz2" &>/dev/null ||
    wget -c "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-$VERSION_libgcrypt.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/libgcrypt-$VERSION_libgcrypt.tar.bz2"
    cd "libgcrypt-$VERSION_libgcrypt"
    sed '26i\#include <ws2tcpip.h>' -i src/gcrypt.h.in
    sed '26i\#include <ws2tcpip.h>' -i src/ath.h
    sed 's,sys/times.h,sys/time.h,' -i cipher/random.c
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-gpg-error-prefix="$PREFIX/$TARGET"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   GnuTLS
#
#   http://www.gnu.org/software/gnutls/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "gnutls-$VERSION_gnutls.tar.bz2" &>/dev/null ||
    wget -c "ftp://ftp.gnutls.org/pub/gnutls/gnutls-$VERSION_gnutls.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/gnutls-$VERSION_gnutls.tar.bz2"
    cd "gnutls-$VERSION_gnutls"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-libgcrypt-prefix="$PREFIX/$TARGET" \
        --disable-nls \
        --with-included-opencdk \
        --with-included-libtasn1 \
        --with-included-libcfg \
        --with-included-lzo
    make install bin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
    ;;

esac


#---
#   cURL
#
#   http://curl.haxx.se/libcurl/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "curl-$VERSION_curl.tar.bz2" &>/dev/null ||
    wget -c "http://curl.haxx.se/download/curl-$VERSION_curl.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/curl-$VERSION_curl.tar.bz2"
    cd "curl-$VERSION_curl"
    sed 's,GNUTLS_ENABLED = 1,GNUTLS_ENABLED=1,' -i configure
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-gnutls
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   libpng
#
#   http://www.libpng.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "libpng-$VERSION_libpng.tar.bz2" &>/dev/null ||
    wget -c "http://downloads.sourceforge.net/libpng/libpng-$VERSION_libpng.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/libpng-$VERSION_libpng.tar.bz2"
    cd "libpng-$VERSION_libpng"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   jpeg
#
#   http://www.ijg.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "jpegsrc.v$VERSION_jpeg.tar.gz" &>/dev/null ||
    wget -c "http://www.ijg.org/files/jpegsrc.v$VERSION_jpeg.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/jpegsrc.v$VERSION_jpeg.tar.gz"
    cd "jpeg-$VERSION_jpeg"
    ./configure \
        CC="$TARGET-gcc" RANLIB="$TARGET-ranlib" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    make install-lib
    ;;

esac


#---
#   LibTIFF
#
#   http://www.remotesensing.org/libtiff/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "tiff-$VERSION_tiff.tar.gz" &>/dev/null ||
    wget -c "ftp://ftp.remotesensing.org/pub/libtiff/tiff-$VERSION_tiff.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/tiff-$VERSION_tiff.tar.gz"
    cd "tiff-$VERSION_tiff"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        PTHREAD_LIBS="-lpthread -lws2_32" \
        --without-x
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   giflib
#
#   http://sourceforge.net/projects/libungif
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "giflib-$VERSION_giflib.tar.bz2" &>/dev/null ||
    wget -c "http://downloads.sourceforge.net/libungif/giflib-$VERSION_giflib.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/giflib-$VERSION_giflib.tar.bz2"
    cd "giflib-$VERSION_giflib"
    sed 's,u_int32_t,unsigned int,' -i configure
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --without-x
    make -C lib install
    ;;

esac


#---
#   freetype
#
#   http://freetype.sourceforge.net/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "freetype-$VERSION_freetype.tar.bz2" &>/dev/null ||
    wget -c "http://download.savannah.gnu.org/releases/freetype/freetype-$VERSION_freetype.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/freetype-$VERSION_freetype.tar.bz2"
    cd "freetype-$VERSION_freetype"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    make install
    ;;

esac


#---
#   fontconfig
#
#   http://fontconfig.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "fontconfig-$VERSION_fontconfig.tar.gz" &>/dev/null ||
    wget -c "http://fontconfig.org/release/fontconfig-$VERSION_fontconfig.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/fontconfig-$VERSION_fontconfig.tar.gz"
    cd "fontconfig-$VERSION_fontconfig"
    sed 's,^install-data-local:.*,install-data-local:,' -i src/Makefile.in
    ./configure \
        --with-arch="$BUILD" --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-freetype-config="$PREFIX/$TARGET/bin/freetype-config" \
        --enable-libxml2 \
        LIBXML2_CFLAGS="`$PREFIX/$TARGET/bin/xml2-config --cflags`" \
        LIBXML2_LIBS="`$PREFIX/$TARGET/bin/xml2-config --libs`"
    make -C src install
    make -C fontconfig install
    ;;

esac


#---
#   GD
#   (without support for xpm)
#
#   http://www.libgd.org/
#---

case "$1" in

--download)
cd "$DOWNLOAD"
tar tfj "gd-$VERSION_gd.tar.bz2" &>/dev/null ||
    wget -c "http://www.libgd.org/releases/gd-$VERSION_gd.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/gd-$VERSION_gd.tar.bz2"
    cd "gd-$VERSION_gd"
    touch aclocal.m4
    touch config.hin
    touch Makefile.in
    sed 's,-lX11 ,,g' -i configure
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-freetype="$PREFIX/$TARGET" \
        --without-x \
        LIBPNG12_CONFIG="$PREFIX/$TARGET/bin/libpng12-config" \
        LIBPNG_CONFIG="$PREFIX/$TARGET/bin/libpng-config" \
        CFLAGS="-DNONDLL -DXMD_H -L$PREFIX/$TARGET/lib" \
        LIBS="`$PREFIX/$TARGET/bin/xml2-config --libs`"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   SDL
#
#   http://www.libsdl.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "SDL-$VERSION_SDL.tar.gz" &>/dev/null ||
    wget -c "http://www.libsdl.org/release/SDL-$VERSION_SDL.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/SDL-$VERSION_SDL.tar.gz"
    cd "SDL-$VERSION_SDL"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --disable-debug \
        --prefix="$PREFIX/$TARGET"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   smpeg
#
#   http://icculus.org/smpeg/
#   http://packages.debian.org/unstable/source/smpeg
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "smpeg_$VERSION_smpeg.orig.tar.gz" &>/dev/null ||
    wget -c "http://ftp.debian.org/debian/pool/main/s/smpeg/smpeg_$VERSION_smpeg.orig.tar.gz"
    #svn checkout -r ... svn://svn.icculus.org/smpeg/trunk ...
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/smpeg_$VERSION_smpeg.orig.tar.gz"
    cd "smpeg-$VERSION_smpeg.orig"
    #cp -R "$DOWNLOAD/smpeg-trunk" smpeg-trunk
    #cd smpeg-trunk
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --disable-debug \
        --prefix="$PREFIX/$TARGET" \
        --with-sdl-prefix="$PREFIX/$TARGET" \
        --disable-gtk-player \
        --disable-opengl-player
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   SDL_mixer
#
#   http://www.libsdl.org/projects/SDL_mixer/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "SDL_mixer-$VERSION_SDL_mixer.tar.gz" &>/dev/null ||
    wget -c "http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-$VERSION_SDL_mixer.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/SDL_mixer-$VERSION_SDL_mixer.tar.gz"
    cd "SDL_mixer-$VERSION_SDL_mixer"
    sed 's,for path in /usr/local; do,for path in; do,' -i configure
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --with-sdl-prefix="$PREFIX/$TARGET" \
        --with-smpeg-prefix="$PREFIX/$TARGET"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   GEOS
#
#   http://geos.refractions.net/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfj "geos-$VERSION_geos.tar.bz2" &>/dev/null ||
    wget -c "http://geos.refractions.net/geos-$VERSION_geos.tar.bz2"
    ;;

--build)
    cd "$SOURCE"
    tar xfvj "$DOWNLOAD/geos-$VERSION_geos.tar.bz2"
    cd "geos-$VERSION_geos"
    sed 's,-lgeos,-lgeos -lstdc++,' -i tools/geos-config.in
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        --disable-swig
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   proj
#
#   http://www.remotesensing.org/proj/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "proj-$VERSION_proj.tar.gz" &>/dev/null ||
    wget -c "ftp://ftp.remotesensing.org/proj/proj-$VERSION_proj.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/proj-$VERSION_proj.tar.gz"
    cd "proj-$VERSION_proj"
    sed 's,install-exec-local[^:],,' -i src/Makefile.in
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    make install bin_PROGRAMS= noinst_PROGRAMS=
    ;;

esac


#---
#   GeoTiff
#
#   http://www.remotesensing.org/geotiff/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "libgeotiff-$VERSION_libgeotiff.tar.gz" &>/dev/null ||
    wget -c "ftp://ftp.remotesensing.org/pub/geotiff/libgeotiff/libgeotiff-$VERSION_libgeotiff.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/libgeotiff-$VERSION_libgeotiff.tar.gz"
    cd "libgeotiff-$VERSION_libgeotiff"
    sed 's,/usr/local,@prefix@,' -i bin/Makefile.in
    touch configure
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET"
    make all install EXEEXT=.remove-me
    rm -fv "$PREFIX/$TARGET"/bin/*.remove-me
    ;;

esac


#---
#   GDAL
#
#   http://www.gdal.org/
#---

case "$1" in

--download)
    cd "$DOWNLOAD"
    tar tfz "gdal-$VERSION_gdal.tar.gz" &>/dev/null ||
    wget -c "http://www.gdal.org/dl/gdal-$VERSION_gdal.tar.gz"
    ;;

--build)
    cd "$SOURCE"
    tar xfvz "$DOWNLOAD/gdal-$VERSION_gdal.tar.gz"
    cd "gdal-$VERSION_gdal"
    ./configure \
        --build="$BUILD" --host="$TARGET" \
        --disable-shared \
        --prefix="$PREFIX/$TARGET" \
        LIBS="-ljpeg" \
        --with-png="$PREFIX/$TARGET" \
        --with-libtiff="$PREFIX/$TARGET" \
        --with-geotiff="$PREFIX/$TARGET" \
        --with-jpeg="$PREFIX/$TARGET" \
        --with-gif="$PREFIX/$TARGET" \
        --with-curl="$PREFIX/$TARGET/bin/curl-config" \
        --with-geos="$PREFIX/$TARGET/bin/geos-config" \
        --without-python \
        --without-ngpython
    make lib-target
    make install-lib
    make -C port  install
    make -C gcore install
    make -C frmts install
    make -C alg   install
    make -C ogr   install OGR_ENABLED=
    make -C apps  install BIN_LIST=
    ;;

esac


#---
#   Create package
#---

case "$1" in

--build)
    cd "$PREFIX"
    tar cv \
        bin lib libexec \
        "$TARGET/bin" "$TARGET/include" "$TARGET/lib" \
    | gzip -9 >"$ROOT/mingw_cross_env.tar.gz"
    ;;

esac