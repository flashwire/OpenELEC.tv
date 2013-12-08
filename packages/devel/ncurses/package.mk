################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="ncurses"
PKG_VERSION="5.7"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://www.gnu.org/software/ncurses/"
PKG_URL="http://ftp.gnu.org/pub/gnu/ncurses/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS=""
PKG_BUILD_DEPENDS_HOST=""
PKG_BUILD_DEPENDS_TARGET="toolchain ncurses:host"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="ncurses: The ncurses (new curses) library"
PKG_LONGDESC="The ncurses (new curses) library is a free software emulation of curses in System V Release 4.0, and more. It uses terminfo format, supports pads and color and multiple highlights and forms characters and function-key mapping, and has all the other SYSV-curses enhancements over BSD curses."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

export BUILD_CC="$HOST_CC"
export BUILD_CPPFLAGS="$HOST_CPPFLAGS -I../include"
export BUILD_CFLAGS="$HOST_CFLAGS"
export BUILD_LDFLAGS="$HOST_LDFLAGS"

PKG_CONFIGURE_OPTS_HOST="--with-shared"
PKG_CONFIGURE_OPTS_TARGET="--without-cxx \
                           --without-cxx-binding \
                           --without-ada \
                           --without-progs \
                           --with-shared \
                           --with-normal \
                           --without-debug \
                           --without-profile \
                           --with-termlib \
                           --without-dbmalloc \
                           --without-dmalloc \
                           --without-gpm \
                           --disable-rpath \
                           --disable-overwrite \
                           --enable-database \
                           --disable-big-core \
                           --enable-termcap \
                           --enable-getcap \
                           --disable-getcap-cache \
                           --disable-bsdpad \
                           --without-rcs-ids \
                           --enable-ext-funcs \
                           --disable-const \
                           --enable-no-padding \
                           --disable-sigwinch \
                           --disable-tcap-names \
                           --without-develop \
                           --disable-hard-tabs \
                           --disable-xmc-glitch \
                           --disable-hashmap \
                           --disable-safe-sprintf \
                           --disable-scroll-hints \
                           --disable-widec \
                           --disable-echo \
                           --disable-warnings \
                           --disable-assertions"

pre_configure_target() {
  # causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.
  strip_linker_plugin
}

make_host() {
  make -C include
  make -C progs tic
}

makeinstall_host() {
  cp progs/tic $ROOT/$TOOLCHAIN/bin
  cp lib/*.so* $ROOT/$TOOLCHAIN/lib
  make -C include install
}

make_target() {
  make -C include
  make -C ncurses
  make -C panel
  make -C menu
  make -C form
}

makeinstall_target() {
  $MAKEINSTALL -C include
  $MAKEINSTALL -C ncurses
  $MAKEINSTALL -C panel
  $MAKEINSTALL -C menu
  $MAKEINSTALL -C form

  cp misc/ncurses-config $ROOT/$TOOLCHAIN/bin
    chmod +x $ROOT/$TOOLCHAIN/bin/ncurses-config
    $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $ROOT/$TOOLCHAIN/bin/ncurses-config

  make DESTDIR=$INSTALL -C ncurses install
  make DESTDIR=$INSTALL -C panel install
  make DESTDIR=$INSTALL -C menu install
  make DESTDIR=$INSTALL -C form install
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/share/terminfo/l
    TERMINFO=$INSTALL/usr/share/terminfo $ROOT/$TOOLCHAIN/bin/tic -xe linux \
      $ROOT/$PKG_BUILD/misc/terminfo.src

  mkdir -p $INSTALL/usr/share/terminfo/s
    TERMINFO=$INSTALL/usr/share/terminfo $ROOT/$TOOLCHAIN/bin/tic -xe screen \
      $ROOT/$PKG_BUILD/misc/terminfo.src

  mkdir -p $INSTALL/usr/share/terminfo/v
    TERMINFO=$INSTALL/usr/share/terminfo $ROOT/$TOOLCHAIN/bin/tic -xe vt100 \
      $ROOT/$PKG_BUILD/misc/terminfo.src

  mkdir -p $INSTALL/usr/share/terminfo/x
    TERMINFO=$INSTALL/usr/share/terminfo $ROOT/$TOOLCHAIN/bin/tic -xe xterm \
      $ROOT/$PKG_BUILD/misc/terminfo.src
    TERMINFO=$INSTALL/usr/share/terminfo $ROOT/$TOOLCHAIN/bin/tic -xe xterm-color \
      $ROOT/$PKG_BUILD/misc/terminfo.src
}