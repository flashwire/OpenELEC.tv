################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="taglib"
PKG_VERSION="1.8"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://taglib.github.com/"
PKG_URL="https://github.com/downloads/taglib/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain cmake:host zlib"
PKG_PRIORITY="optional"
PKG_SECTION="audio"
PKG_SHORTDESC="taglib: a library for reading and editing the meta-data of several popular audio formats."
PKG_LONGDESC="TagLib is a library for reading and editing the meta-data of several popular audio formats."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

# package specific configure options
configure_target() {
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF -DCMAKE_INSTALL_PREFIX=/usr ..
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
