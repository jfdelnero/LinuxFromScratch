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
SRC_PACKAGE_BUILD_GPERF="@COMMON@""http://ftp.gnu.org/pub/gnu/gperf/gperf-3.0.4.tar.gz"
SRC_PACKAGE_BUILD_LIBFFI="@COMMON@""https://www.mirrorservice.org/sites/sourceware.org/pub/libffi/libffi-3.2.tar.gz"
SRC_PACKAGE_BUILD_XMLEXPAT="@COMMON@""https://downloads.sourceforge.net/project/expat/expat/2.2.5/expat-2.2.5.tar.bz2"
SRC_PACKAGE_BUILD_LIBXML2="@COMMON@""http://xmlsoft.org/sources/libxml2-2.9.7.tar.gz"

SRC_PACKAGE_BINUTILS="@COMMON@""http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz"

SRC_PACKAGE_GCC="@COMMON@""http://ftp.gnu.org/gnu/gcc/gcc-6.4.0/gcc-6.4.0.tar.gz"
SRC_PACKAGE_GCC_MPFR="@COMMON@""http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.2.tar.xz"
SRC_PACKAGE_GCC_GMP="@COMMON@""https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
SRC_PACKAGE_GCC_MPC="@COMMON@""http://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz"
SRC_PACKAGE_GCC_ISL="@COMMON@""ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.15.tar.bz2"
SRC_PACKAGE_GCC_CLOOG="@COMMON@""ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz"

SRC_PACKAGE_GLIBC="@COMMON@""http://ftp.gnu.org/gnu/glibc/glibc-2.25.tar.xz"

SRC_PACKAGE_BUSYBOX="@COMMON@""https://busybox.net/downloads/busybox-1.30.1.tar.bz2"
SRC_PACKAGE_UTILLINUX="@COMMON@""https://www.kernel.org/pub/linux/utils/util-linux/v2.34/util-linux-2.34.tar.gz"

SRC_PACKAGE_LIBELF="@COMMON@""https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz"

SRC_PACKAGE_LIBFFI="@COMMON@""https://www.mirrorservice.org/sites/sourceware.org/pub/libffi/libffi-3.2.tar.gz"
SRC_PACKAGE_LIBXML2="@COMMON@""http://xmlsoft.org/sources/libxml2-2.9.7.tar.gz"
SRC_PACKAGE_XMLEXPAT="@COMMON@""https://downloads.sourceforge.net/project/expat/expat/2.2.5/expat-2.2.5.tar.bz2"
SRC_PACKAGE_ZLIB="@COMMON@""http://zlib.net/zlib-1.2.11.tar.gz"
SRC_PACKAGE_LIBEVENT="@COMMON@""https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz"

#
# Debug support
#
CUR_PART=${DEBUG_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_GDB="@COMMON@""https://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.gz"
SRC_PACKAGE_STRACE="@COMMON@""https://strace.io/files/5.2/strace-5.2.tar.xz"
#SRC_PACKAGE_LTRACE="@COMMON@""https://fossies.org/linux/misc/ltrace-0.7.3.tar.gz"
SRC_PACKAGE_VALGRIND="@COMMON@""ftp://sourceware.org/pub/valgrind/valgrind-3.15.0.tar.bz2"

fi

#
# Network support
#

CUR_PART=${NETWORK_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_LIBMNL="@COMMON@""http://netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2"
SRC_PACKAGE_LIBNFTNL="@COMMON@""https://www.netfilter.org/projects/libnftnl/files/libnftnl-1.1.3.tar.bz2"
SRC_PACKAGE_IPTABLES="@COMMON@""https://www.netfilter.org/projects/iptables/files/iptables-1.8.3.tar.bz2"
SRC_PACKAGE_DHCPSERVER="@COMMON@""ftp://ftp.isc.org/isc/dhcp/4.4.1/dhcp-4.4.1.tar.gz"
SRC_PACKAGE_DHCPSERVER_PATCH_001="@COMMON@""http://wiki.beyondlogic.org/patches/dhcp-4.3.0b1.bind_arm-linux-gnueabi.patch"
SRC_PACKAGE_DHCPSERVER_PATCH_002="@COMMON@""http://wiki.beyondlogic.org/patches/bind-9.9.5rc1.gen_crosscompile.patch"

fi

#
# Wireless support
#
CUR_PART=${WIRELESS_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_WIRELESSTOOLS="@COMMON@""http://www.labs.hpe.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz"
SRC_PACKAGE_LIBNL3="@COMMON@""https://www.infradead.org/~tgr/libnl/files/libnl-3.2.25.tar.gz"
SRC_PACKAGE_LIBNL1="@COMMON@""http://www.infradead.org/~tgr/libnl/files/libnl-1.1.4.tar.gz"
SRC_PACKAGE_IW="@COMMON@""https://www.kernel.org/pub/software/network/iw/iw-5.0.1.tar.gz"
SRC_PACKAGE_WPASUPPLICANT="@COMMON@""http://w1.fi/releases/wpa_supplicant-2.8.tar.gz"
SRC_PACKAGE_HOSTAPD="@COMMON@""http://w1.fi/releases/hostapd-2.8.tar.gz"
SRC_PACKAGE_RFKILL="@COMMON@""https://www.kernel.org/pub/software/network/rfkill/rfkill-0.5.tar.gz"

fi

#
# Services
#

SRC_PACKAGE_OPENSSL="@COMMON@""ftp://ftp.openssl.org/source/openssl-1.0.2s.tar.gz"
SRC_PACKAGE_OPENSSH="@COMMON@""http://ftp.fr.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.0p1.tar.gz"
SRC_PACKAGE_NTP="@COMMON@""http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p13.tar.gz"
SRC_PACKAGE_VSFTPD="@COMMON@""https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz"
SRC_PACKAGE_LIGHTTPD="@COMMON@""https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.54.tar.xz"
#SRC_PACKAGE_CVS=cvs-1.11.23.tar.gz
SRC_PACKAGE_PXESERVER="@COMMON@""https://github.com/jfdelnero/pxe-server/releases/download/PXE_1_4_2/pxe-1.4.2.tar.gz"
SRC_PACKAGE_TFTPD="@COMMON@""https://kernel.org/pub/software/network/tftp/tftp-hpa/tftp-hpa-5.2.tar.gz"
SRC_PACKAGE_UMTPRD="@COMMON@""https://github.com/viveris/uMTP-Responder/archive/umtprd-0.8.6.tar.gz"

SRC_PACKAGE_LIBGMP="@COMMON@""https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
SRC_PACKAGE_MAILUTILS="@COMMON@""ftp://ftp.gnu.org/gnu/mailutils/mailutils-3.7.tar.xz"
SRC_PACKAGE_NETTLE="@COMMON@""https://ftp.gnu.org/gnu/nettle/nettle-3.5.1.tar.gz"
SRC_PACKAGE_GNUTLS="@COMMON@""https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.8.tar.xz"
SRC_PACKAGE_MSMTP="@COMMON@""https://marlam.de/msmtp/releases/msmtp-1.8.5.tar.xz"

#
# Graphic Stack
#
CUR_PART=${GFX_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_LIBPNG="@COMMON@""ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng16/libpng-1.6.34.tar.xz"
#SRC_PACKAGE_LIBPCIACCESS="@COMMON@""https://www.x.org/archive/individual/lib/libpciaccess-0.14.tar.gz"
SRC_PACKAGE_LIBDRM="@COMMON@""https://dri.freedesktop.org/libdrm/libdrm-2.4.92.tar.gz"
SRC_PACKAGE_MESA="@COMMON@""https://mesa.freedesktop.org/archive/mesa-18.1.1.tar.xz"
SRC_PACKAGE_GLEW="@COMMON@""https://downloads.sourceforge.net/project/glew/glew/2.1.0/glew-2.1.0.tgz"
SRC_PACKAGE_GLU="@COMMON@""ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.0.tar.gz"
#SRC_PACKAGE_GLUT=glut.tar.gz

SRC_PACKAGE_FREETYPE="@COMMON@""https://downloads.sourceforge.net/project/freetype/freetype2/2.8.1/freetype-2.8.1.tar.bz2"
SRC_PACKAGE_FONTCONFIG="@COMMON@""https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.4.tar.bz2"
SRC_PACKAGE_DIRECTFB="@COMMON@""https://github.com/Distrotech/DirectFB/archive/DIRECTFB_1_7_7.tar.gz"
SRC_PACKAGE_SDL="@COMMON@""https://www.libsdl.org/release/SDL2-2.0.8.tar.gz"
SRC_PACKAGE_SDL_TTF="@COMMON@""https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14.tar.gz"
SRC_PACKAGE_SDL_NET="@COMMON@""https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.1.tar.gz"

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

SRC_PACKAGE_ALSALIB="@COMMON@""ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.6.tar.bz2"
SRC_PACKAGE_ALSAUTILS="@COMMON@""ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.1.6.tar.bz2"
SRC_PACKAGE_SDLMIXER="@COMMON@""https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.2.tar.gz"
fi

#
# Wayland
#

CUR_PART=${WAYLAND_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_MTDEV="@COMMON@""http://bitmath.org/code/mtdev/mtdev-1.1.5.tar.gz"
SRC_PACKAGE_LIBEVDEV="@COMMON@""https://www.freedesktop.org/software/libevdev/libevdev-1.5.6.tar.xz"

SRC_PACKAGE_ATTR="@COMMON@""https://download-mirror.savannah.gnu.org/releases/attr/attr-2.4.47.src.tar.gz"
SRC_PACKAGE_LIBCAP="@COMMON@""https://ftp.osuosl.org/pub/blfs/conglomeration/libcap/libcap-2.25.tar.xz"
SRC_PACKAGE_UTILLINUX="@COMMON@""http://ftp.free.fr/mirrors/ftp.kernel.org/linux/utils/util-linux/v2.31/util-linux-2.31.tar.xz"
SRC_PACKAGE_SYSTEMD="@COMMON@""https://www.freedesktop.org/software/systemd/systemd-221.tar.xz"

SRC_PACKAGE_EUDEV="@COMMON@""https://dev.gentoo.org/~blueness/eudev/eudev-3.2.5.tar.gz"
SRC_PACKAGE_LIBINPUT="@COMMON@""https://www.freedesktop.org/software/libinput/libinput-1.8.4.tar.xz"
SRC_PACKAGE_LIBXKBCOMMON="@COMMON@""https://xkbcommon.org/download/libxkbcommon-0.8.0.tar.xz"
SRC_PACKAGE_PIXMAN="@COMMON@""https://cairographics.org/releases/pixman-0.34.0.tar.gz"
SRC_PACKAGE_CAIRO="@COMMON@""https://www.cairographics.org/releases/cairo-1.14.12.tar.xz"
SRC_PACKAGE_LIBPAM="@COMMON@""http://www.linux-pam.org/library/Linux-PAM-1.3.0.tar.gz"
SRC_PACKAGE_DBUS="@COMMON@""https://dbus.freedesktop.org/releases/dbus/dbus-1.13.4.tar.gz"

SRC_PACKAGE_WAYLAND="@COMMON@""https://wayland.freedesktop.org/releases/wayland-1.15.0.tar.xz"
SRC_PACKAGE_WAYLANDPROTOCOLS="@COMMON@""https://wayland.freedesktop.org/releases/wayland-protocols-1.14.tar.xz"
SRC_PACKAGE_WAYLANDWESTON="@COMMON@""https://wayland.freedesktop.org/releases/weston-4.0.0.tar.xz"

fi

#
# Misc
#

CUR_PART=${HDD_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_SDPARM="@COMMON@""https://fossies.org/linux/misc/sdparm-1.10.tgz"
SRC_PACKAGE_HDIDLE="@COMMON@""http://sources.openelec.tv/mirror/hd-idle/hd-idle-1.04.tgz"

fi

#SRC_PACKAGE_PYTHON="@COMMON@""https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz"
SRC_PACKAGE_PERL="@COMMON@""https://www.cpan.org/src/5.0/perl-5.28.0.tar.gz"
SRC_PACKAGE_PERLCROSS="@COMMON@""https://github.com/arsv/perl-cross/releases/download/1.2/perl-cross-1.2.tar.gz"
#SRC_PACKAGE_LIBUSB=libusb-1.0.21.tar.bz2
#SRC_PACKAGE_LIBUSBGADGET=libusb-gadget.tar.gz

SRC_PACKAGE_LIBNCURSES="@COMMON@""https://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz"
SRC_PACKAGE_NANOEDITOR="@COMMON@""https://www.nano-editor.org/dist/v4/nano-4.3.tar.xz"
SRC_PACKAGE_LIBAIO="@COMMON@""https://releases.pagure.org/libaio/libaio-0.3.112.tar.gz"

SRC_PACKAGE_LIBCURL="@COMMON@""https://curl.haxx.se/download/curl-7.65.2.tar.xz"

SRC_PACKAGE_E2FSPROGS="@COMMON@""https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.44.5/e2fsprogs-1.44.5.tar.gz"

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

SRC_PACKAGE_TARGET_MAKE="@COMMON@""http://ftp.gnu.org/gnu/make/make-4.2.1.tar.gz"

fi

#
# Games
#
CUR_PART=${GAMES_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_MAME="@COMMON@""https://github.com/mamedev/mame/archive/mame0198.tar.gz"
#SRC_PACKAGE_QUAKE3="@COMMON@""quake3-master.tar.gz"
SRC_PACKAGE_DOOM="@COMMON@""https://www.chocolate-doom.org/downloads/3.0.0/chocolate-doom-3.0.0.tar.gz"
SRC_PACKAGE_ROTT="@COMMON@""https://icculus.org/rott/releases/rott-1.1.2.tar.gz"

fi

#SRC_PACKAGE_PCIUTILS="@COMMON@""https://github.com/pciutils/pciutils/archive/v3.6.0.tar.gz"
#SRC_PACKAGE_FLASHROM="@COMMON@""https://download.flashrom.org/releases/flashrom-1.0.tar.bz2"
