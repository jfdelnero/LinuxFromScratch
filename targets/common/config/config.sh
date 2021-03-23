#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Common setup
#

#
# System base + Cross compiler
#

# "Local" build tools/libs 
SRC_PACKAGE_BUILD_GPERF="@COMMON@""https://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz"
SRC_PACKAGE_BUILD_LIBFFI="@COMMON@""https://www.mirrorservice.org/sites/sourceware.org/pub/libffi/libffi-3.3.tar.gz"
SRC_PACKAGE_BUILD_XMLEXPAT="@COMMON@""https://downloads.sourceforge.net/project/expat/expat/2.2.10/expat-2.2.10.tar.bz2"
SRC_PACKAGE_BUILD_LIBXML2="@COMMON@""http://xmlsoft.org/sources/libxml2-2.9.10.tar.gz"
#SRC_PACKAGE_BUILD_CMAKE="@COMMON@""https://github.com/Kitware/CMake/releases/download/v3.19.7/cmake-3.19.7.tar.gz"

SRC_PACKAGE_BINUTILS="@COMMON@""https://ftp.gnu.org/gnu/binutils/binutils-2.36.1.tar.xz"

SRC_PACKAGE_GCC="@COMMON@""https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz"
SRC_PACKAGE_GCC_MPFR="@COMMON@""https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.xz"
SRC_PACKAGE_GCC_GMP="@COMMON@""https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
SRC_PACKAGE_GCC_MPC="@COMMON@""https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz"
SRC_PACKAGE_GCC_ISL="@COMMON@""ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2"
SRC_PACKAGE_GCC_CLOOG="@COMMON@""ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz"

SRC_PACKAGE_LIBTIRPC="@COMMON@""https://downloads.sourceforge.net/libtirpc/libtirpc-1.3.1.tar.bz2"
SRC_PACKAGE_LIBNSL="@COMMON@""https://github.com/thkukuk/libnsl/releases/download/v1.3.0/libnsl-1.3.0.tar.xz"

SRC_PACKAGE_GLIBC="@COMMON@""https://ftp.gnu.org/gnu/glibc/glibc-2.33.tar.xz"

SRC_PACKAGE_BUSYBOX="@COMMON@""https://busybox.net/downloads/busybox-1.33.0.tar.bz2"
SRC_PACKAGE_UTILLINUX="@COMMON@""https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.tar.xz"

SRC_PACKAGE_LIBELF="@COMMON@""https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz"

SRC_PACKAGE_LIBFFI="@COMMON@""https://www.mirrorservice.org/sites/sourceware.org/pub/libffi/libffi-3.3.tar.gz"
SRC_PACKAGE_LIBXML2="@COMMON@""http://xmlsoft.org/sources/libxml2-2.9.10.tar.gz"
SRC_PACKAGE_XMLEXPAT="@COMMON@""https://downloads.sourceforge.net/project/expat/expat/2.2.5/expat-2.2.5.tar.bz2"
SRC_PACKAGE_ZLIB="@COMMON@""https://zlib.net/zlib-1.2.11.tar.gz"
SRC_PACKAGE_LIBEVENT="@COMMON@""https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz"

#
# Debug support
#
CUR_PART=${DEBUG_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_GDB="@COMMON@""https://ftp.gnu.org/gnu/gdb/gdb-10.1.tar.xz"
SRC_PACKAGE_STRACE="@COMMON@""https://strace.io/files/5.9/strace-5.9.tar.xz"
#SRC_PACKAGE_LTRACE="@COMMON@""https://fossies.org/linux/misc/ltrace-0.7.3.tar.gz"
SRC_PACKAGE_VALGRIND="@COMMON@""ftp://sourceware.org/pub/valgrind/valgrind-3.17.0.tar.bz2"

fi

#
# Network support
#

CUR_PART=${NETWORK_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_LIBMNL="@COMMON@""http://netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2"
SRC_PACKAGE_LIBNFTNL="@COMMON@""https://www.netfilter.org/projects/libnftnl/files/libnftnl-1.1.9.tar.bz2"
SRC_PACKAGE_IPTABLES="@COMMON@""https://www.netfilter.org/projects/iptables/files/iptables-1.8.7.tar.bz2"
SRC_PACKAGE_DHCPSERVER="@COMMON@""ftp://ftp.isc.org/isc/dhcp/4.4.2/dhcp-4.4.2.tar.gz"
#SRC_PACKAGE_DHCPSERVER_PATCH_001="@COMMON@""http://wiki.beyondlogic.org/patches/dhcp-4.3.0b1.bind_arm-linux-gnueabi.patch"
#SRC_PACKAGE_DHCPSERVER_PATCH_002="@COMMON@""http://wiki.beyondlogic.org/patches/bind-9.9.5rc1.gen_crosscompile.patch"

fi

#
# Wireless support
#
CUR_PART=${WIRELESS_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_WIRELESSTOOLS="@COMMON@""https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz"
SRC_PACKAGE_LIBNL3="@COMMON@""https://www.infradead.org/~tgr/libnl/files/libnl-3.2.25.tar.gz"
SRC_PACKAGE_LIBNL1="@COMMON@""https://www.infradead.org/~tgr/libnl/files/libnl-1.1.4.tar.gz"
SRC_PACKAGE_IW="@COMMON@""https://www.kernel.org/pub/software/network/iw/iw-5.9.tar.xz"
SRC_PACKAGE_WPASUPPLICANT="@COMMON@""https://w1.fi/releases/wpa_supplicant-2.9.tar.gz"
SRC_PACKAGE_HOSTAPD="@COMMON@""https://w1.fi/releases/hostapd-2.9.tar.gz"
SRC_PACKAGE_RFKILL="@COMMON@""https://www.kernel.org/pub/software/network/rfkill/rfkill-1.0.tar.gz"

fi

#
# Services
#

SRC_PACKAGE_OPENSSL="@COMMON@""https://ftp.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz"
SRC_PACKAGE_OPENSSH="@COMMON@""https://ftp.fr.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.5p1.tar.gz"
SRC_PACKAGE_NTP="@COMMON@""http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p15.tar.gz"
SRC_PACKAGE_VSFTPD="@COMMON@""https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz"
SRC_PACKAGE_LIGHTTPD="@COMMON@""https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.59.tar.xz"
#SRC_PACKAGE_CVS=cvs-1.11.23.tar.gz
SRC_PACKAGE_PXESERVER="@COMMON@""https://github.com/jfdelnero/pxe-server/releases/download/PXE_1_4_2/pxe-1.4.2.tar.gz"
SRC_PACKAGE_TFTPD="@COMMON@""https://kernel.org/pub/software/network/tftp/tftp-hpa/tftp-hpa-5.2.tar.gz"
SRC_PACKAGE_UMTPRD="@COMMON@""https://github.com/viveris/uMTP-Responder/archive/refs/tags/umtprd-1.3.10.tar.gz"

SRC_PACKAGE_LIBGMP="@COMMON@""https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
SRC_PACKAGE_MAILUTILS="@COMMON@""https://ftp.gnu.org/gnu/mailutils/mailutils-3.12.tar.xz"
SRC_PACKAGE_NETTLE="@COMMON@""https://ftp.gnu.org/gnu/nettle/nettle-3.7.tar.gz"
SRC_PACKAGE_GNUTLS="@COMMON@""https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.1.tar.xz"
SRC_PACKAGE_MSMTP="@COMMON@""https://marlam.de/msmtp/releases/msmtp-1.8.15.tar.xz"
SRC_PACKAGE_SAMBA="@COMMON@""https://download.samba.org/pub/samba/stable/samba-3.6.25.tar.gz"

#
# Graphic Stack
#

CUR_PART=${LIBGFX_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_LIBGD="@COMMON@""https://github.com/libgd/libgd/releases/download/gd-2.3.2/libgd-2.3.2.tar.xz"
SRC_PACKAGE_LIBPNG="@COMMON@""https://download.sourceforge.net/libpng/libpng-1.6.37.tar.xz"
SRC_PACKAGE_FREETYPE="@COMMON@""https://downloads.sourceforge.net/project/freetype/freetype2/2.10.4/freetype-2.10.4.tar.xz"
SRC_PACKAGE_FONTCONFIG="@COMMON@""https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.93.tar.xz"

fi

CUR_PART=${GFX_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

#SRC_PACKAGE_LIBPCIACCESS="@COMMON@""https://www.x.org/archive/individual/lib/libpciaccess-0.14.tar.gz"
SRC_PACKAGE_LIBDRM="@COMMON@""https://dri.freedesktop.org/libdrm/libdrm-2.4.104.tar.xz"

SRC_PACKAGE_DIRECTFB="@COMMON@""https://github.com/Distrotech/DirectFB/archive/DIRECTFB_1_7_7.tar.gz"
SRC_PACKAGE_SDL="@COMMON@""https://www.libsdl.org/release/SDL2-2.0.14.tar.gz"
SRC_PACKAGE_SDL_TTF="@COMMON@""https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.15.tar.gz"
SRC_PACKAGE_SDL_NET="@COMMON@""https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.1.tar.gz"

fi

CUR_PART=${GFX3D_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_MESA="@COMMON@""https://mesa.freedesktop.org/archive/mesa-21.0.0.tar.xz"
SRC_PACKAGE_GLEW="@COMMON@""https://downloads.sourceforge.net/project/glew/glew/2.2.0/glew-2.2.0.tgz"
SRC_PACKAGE_GLU="@COMMON@""ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.1.tar.gz"
#SRC_PACKAGE_GLUT=glut.tar.gz

# Default Mesa 3D setting : software raster only.
export MESA_DRI_DRV="swrast"
export MESA_GALLIUM_DRV="swrast"
export DRM_SUPPORT=""

fi

#
# Audio Stack
#
CUR_PART=${AUDIO_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_ALSALIB="@COMMON@""ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.2.4.tar.bz2"
SRC_PACKAGE_ALSAUTILS="@COMMON@""ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.2.4.tar.bz2"
SRC_PACKAGE_SDLMIXER="@COMMON@""https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz"
fi

#
# Wayland
#

CUR_PART=${WAYLAND_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_MTDEV="@COMMON@""https://bitmath.org/code/mtdev/mtdev-1.1.6.tar.bz2"
SRC_PACKAGE_LIBEVDEV="@COMMON@""https://www.freedesktop.org/software/libevdev/libevdev-1.11.0.tar.xz"

SRC_PACKAGE_ATTR="@COMMON@""https://download-mirror.savannah.gnu.org/releases/attr/attr-2.5.1.tar.xz"
SRC_PACKAGE_LIBCAP="@COMMON@""https://ftp.osuosl.org/pub/blfs/conglomeration/libcap/libcap-2.49.tar.xz"
SRC_PACKAGE_UTILLINUX="@COMMON@""http://ftp.free.fr/mirrors/ftp.kernel.org/linux/utils/util-linux/v2.36/util-linux-2.36.tar.xz"
SRC_PACKAGE_SYSTEMD="@COMMON@""https://www.freedesktop.org/software/systemd/systemd-221.tar.xz"

SRC_PACKAGE_EUDEV="@COMMON@""https://dev.gentoo.org/~blueness/eudev/eudev-3.2.9.tar.gz"
SRC_PACKAGE_LIBINPUT="@COMMON@""https://www.freedesktop.org/software/libinput/libinput-1.17.0.tar.xz"
SRC_PACKAGE_LIBXKBCOMMON="@COMMON@""https://xkbcommon.org/download/libxkbcommon-1.1.0.tar.xz"
SRC_PACKAGE_PIXMAN="@COMMON@""https://cairographics.org/releases/pixman-0.40.0.tar.gz"
SRC_PACKAGE_CAIRO="@COMMON@""https://www.cairographics.org/releases/cairo-1.16.0.tar.xz"
SRC_PACKAGE_LIBPAM="@COMMON@""http://www.linux-pam.org/library/Linux-PAM-1.3.0.tar.gz"
SRC_PACKAGE_DBUS="@COMMON@""https://dbus.freedesktop.org/releases/dbus/dbus-1.13.18.tar.xz"

SRC_PACKAGE_WAYLAND="@COMMON@""https://wayland.freedesktop.org/releases/wayland-1.19.0.tar.xz"
SRC_PACKAGE_WAYLANDPROTOCOLS="@COMMON@""https://wayland.freedesktop.org/releases/wayland-protocols-1.20.tar.xz"
SRC_PACKAGE_WAYLANDWESTON="@COMMON@""https://wayland.freedesktop.org/releases/weston-8.0.91.tar.xz"

fi

#
# Misc
#

CUR_PART=${HDD_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_SDPARM="@COMMON@""https://fossies.org/linux/misc/sdparm-1.11.tgz"
SRC_PACKAGE_HDIDLE="@COMMON@""https://sources.openelec.tv/mirror/hd-idle/hd-idle-1.04.tgz"

fi

#SRC_PACKAGE_PYTHON="@COMMON@""https://www.python.org/ftp/python/3.9.2/Python-3.9.2.tar.xz"
SRC_PACKAGE_PERL="@COMMON@""https://www.cpan.org/src/5.0/perl-5.32.1.tar.gz"
SRC_PACKAGE_PERLCROSS="@COMMON@""https://github.com/arsv/perl-cross/releases/download/1.3.5/perl-cross-1.3.5.tar.gz"
#SRC_PACKAGE_LIBUSB=libusb-1.0.21.tar.bz2
#SRC_PACKAGE_LIBUSBGADGET=libusb-gadget.tar.gz

SRC_PACKAGE_LIBNCURSES="@COMMON@""https://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz"
SRC_PACKAGE_NANOEDITOR="@COMMON@""https://www.nano-editor.org/dist/v5/nano-5.6.tar.xz"
SRC_PACKAGE_LIBAIO="@COMMON@""https://releases.pagure.org/libaio/libaio-0.3.112.tar.gz"

SRC_PACKAGE_LIBCURL="@COMMON@""https://curl.se/download/curl-7.75.0.tar.xz"

SRC_PACKAGE_E2FSPROGS="@COMMON@""https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.46.2/e2fsprogs-1.46.2.tar.xz"

#
# Target build system
#

CUR_PART=${TARGET_BUILD_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

# Target binutils/gcc
SRC_PACKAGE_TARGET_BINUTILS=${SRC_PACKAGE_BINUTILS}

SRC_PACKAGE_TARGET_GCC=${SRC_PACKAGE_GCC}
SRC_PACKAGE_TARGET_GCC_MPFR=${SRC_PACKAGE_GCC_MPFR}
SRC_PACKAGE_TARGET_GCC_GMP=${SRC_PACKAGE_GCC_GMP}
SRC_PACKAGE_TARGET_GCC_MPC=${SRC_PACKAGE_GCC_MPC}
SRC_PACKAGE_TARGET_GCC_ISL=${SRC_PACKAGE_GCC_ISL}
SRC_PACKAGE_TARGET_GCC_CLOOG=${SRC_PACKAGE_GCC_CLOOG}

SRC_PACKAGE_TARGET_MAKE="@COMMON@""https://ftp.gnu.org/gnu/make/make-4.3.tar.gz"

fi

#
# Games
#
CUR_PART=${GAMES_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_MAME="@COMMON@""https://github.com/mamedev/mame/archive/mame0198.tar.gz"
#SRC_PACKAGE_QUAKE3="@COMMON@""quake3-master.tar.gz"
SRC_PACKAGE_DOOM="@COMMON@""https://www.chocolate-doom.org/downloads/3.0.1/chocolate-doom-3.0.1.tar.gz"
SRC_PACKAGE_ROTT="@COMMON@""https://icculus.org/rott/releases/rott-1.1.2.tar.gz"

fi

#SRC_PACKAGE_PCIUTILS="@COMMON@""https://github.com/pciutils/pciutils/archive/v3.6.0.tar.gz"
#SRC_PACKAGE_FLASHROM="@COMMON@""https://download.flashrom.org/releases/flashrom-1.0.tar.bz2"
#SRC_PACKAGE_FSWEBCAM="@COMMON@""https://www.sanslogic.co.uk/fswebcam/files/fswebcam-20140113.tar.gz"

