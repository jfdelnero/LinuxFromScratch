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
SRC_PACKAGE_BUILD_BINUTILS="@COMMON@""https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.xz"
SRC_PACKAGE_BUILD_GCC="@COMMON@""https://ftp.gnu.org/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.gz"
SRC_PACKAGE_BUILD_GCC_MPFR="@COMMON@""https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz"
SRC_PACKAGE_BUILD_GCC_GMP="@COMMON@""https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz"
SRC_PACKAGE_BUILD_GCC_MPC="@COMMON@""https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz"
SRC_PACKAGE_BUILD_GCC_ISL="@COMMON@""https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2"
SRC_PACKAGE_BUILD_GCC_CLOOG="@COMMON@""https://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz"
SRC_PACKAGE_BUILD_GPERF="@COMMON@""https://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz"
SRC_PACKAGE_BUILD_LIBFFI="@COMMON@""https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz"
SRC_PACKAGE_BUILD_XMLEXPAT="@COMMON@""https://github.com/libexpat/libexpat/releases/download/R_2_4_9/expat-2.4.9.tar.xz"
SRC_PACKAGE_BUILD_LIBXML2="@COMMON@""http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz"
SRC_PACKAGE_BUILD_CMAKE="@COMMON@""https://github.com/Kitware/CMake/archive/refs/tags/v3.25.1.tar.gz"
SRC_PACKAGE_BUILD_MAKE="@COMMON@""https://ftp.gnu.org/gnu/make/make-4.3.tar.gz"
SRC_PACKAGE_BUILD_LIBNCURSES="@COMMON@""https://ftp.gnu.org/gnu/ncurses/ncurses-6.4.tar.gz"
SRC_PACKAGE_BUILD_OPENSSL="@COMMON@""https://www.openssl.org/source/openssl-3.0.14.tar.gz"
SRC_PACKAGE_BUILD_TEXINFO="@COMMON@""https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.tar.xz"
SRC_PACKAGE_BUILD_READLINE="@COMMON@""http://git.savannah.gnu.org/cgit/readline.git/snapshot/readline-8.2.tar.gz"
#SRC_PACKAGE_BUILD_HEIMDAL="@COMMON@""https://github.com/heimdal/heimdal/releases/download/heimdal-7.8.0/heimdal-7.8.0.tar.gz"
SRC_PACKAGE_BUILD_PYTHON="@COMMON@""https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tar.xz"
SRC_PACKAGE_BUILD_PYTHON_SETUPTOOLS="@COMMON@""https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
SRC_PACKAGE_BUILD_DOS2UNIX="@COMMON@""https://freefr.dl.sourceforge.net/project/dos2unix/dos2unix/7.5.0/dos2unix-7.5.0.tar.gz"
#SRC_PACKAGE_BUILD_BASH="@COMMON@""https://ftp.gnu.org/gnu/bash/bash-5.2.tar.gz"
SRC_PACKAGE_BUILD_NANOEDITOR="@COMMON@""https://www.nano-editor.org/dist/v8/nano-8.1.tar.xz"
SRC_PACKAGE_BUILD_PERL="@COMMON@""https://www.cpan.org/src/5.0/perl-5.36.0.tar.xz"
SRC_PACKAGE_BUILD_PERLPARSEYAPP="@COMMON@""https://cpan.metacpan.org/authors/id/W/WB/WBRASWELL/Parse-Yapp-1.21.tar.gz"
SRC_PACKAGE_BUILD_PERLJSON="@COMMON@""https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
SRC_PACKAGE_BUILD_GNU_M4="@COMMON@""https://ftp.gnu.org/gnu/m4/m4-latest.tar.xz"
SRC_PACKAGE_BUILD_BISON="@COMMON@""https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz"
SRC_PACKAGE_BUILD_HELP2MAN="@COMMON@""https://ftp.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
SRC_PACKAGE_BUILD_LIBTEXTSTYLE="@COMMON@""https://alpha.gnu.org/gnu/gettext/libtextstyle-0.20.5.tar.gz"
SRC_PACKAGE_BUILD_GETTEXT="@COMMON@""https://ftp.gnu.org/pub/gnu/gettext/gettext-0.22.5.tar.xz"
SRC_PACKAGE_BUILD_GAWK="@COMMON@""https://ftp.gnu.org/gnu/gawk/gawk-5.3.0.tar.xz"
SRC_PACKAGE_BUILD_LIBTOOL="@COMMON@""https://mirror.ibcp.fr/pub/gnu/libtool/libtool-2.4.7.tar.xz"
SRC_PACKAGE_BUILD_AUTOCONF="@COMMON@""https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.xz"
SRC_PACKAGE_BUILD_AUTOMAKE="@COMMON@""https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.xz"
SRC_PACKAGE_BUILD_LIBTIRPC="@COMMON@""https://downloads.sourceforge.net/libtirpc/libtirpc-1.3.4.tar.bz2"
SRC_PACKAGE_BUILD_PKGCONFIG="@COMMON@""https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz"
SRC_PACKAGE_BUILD_FLEXBOOTSTRAP="@COMMON@""https://src.fedoraproject.org/repo/pkgs/flex/flex-2.5.33.tar.bz2/343374a00b38d9e39d1158b71af37150/flex-2.5.33.tar.bz2"
SRC_PACKAGE_BUILD_FLEX="@COMMON@""https://github.com/westes/flex/archive/refs/tags/v2.6.4.tar.gz"
SRC_PACKAGE_BUILD_ZLIB="@COMMON@""https://zlib.net/current/zlib.tar.gz"
SRC_PACKAGE_BUILD_LIBTIRPC="@COMMON@""https://downloads.sourceforge.net/libtirpc/libtirpc-1.3.4.tar.bz2"
SRC_PACKAGE_BUILD_LIBNSL="@COMMON@""https://github.com/thkukuk/libnsl/archive/refs/tags/v2.0.1.tar.gz"
SRC_PACKAGE_BUILD_UTILLINUX="@COMMON@""https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.38/util-linux-2.38.tar.xz"
SRC_PACKAGE_BUILD_MESON="@COMMON@""https://github.com/mesonbuild/meson/releases/download/1.4.1/meson-1.4.1.tar.gz"


SRC_PACKAGE_BINUTILS="@COMMON@""https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.xz"

SRC_PACKAGE_GCC="@COMMON@""https://ftp.gnu.org/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.gz"
SRC_PACKAGE_GCC_MPFR="@COMMON@""https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz"
SRC_PACKAGE_GCC_GMP="@COMMON@""https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz"
SRC_PACKAGE_GCC_MPC="@COMMON@""https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz"
SRC_PACKAGE_GCC_ISL="@COMMON@""https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2"
SRC_PACKAGE_GCC_CLOOG="@COMMON@""https://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz"

SRC_PACKAGE_LIBTIRPC="@COMMON@""https://downloads.sourceforge.net/libtirpc/libtirpc-1.3.4.tar.bz2"
SRC_PACKAGE_LIBNSL="@COMMON@""https://github.com/thkukuk/libnsl/archive/refs/tags/v2.0.1.tar.gz"

SRC_PACKAGE_GLIBC="@COMMON@""https://ftp.gnu.org/gnu/glibc/glibc-2.39.tar.xz"

SRC_PACKAGE_BUSYBOX="@COMMON@""https://busybox.net/downloads/busybox-1.35.0.tar.bz2"
SRC_PACKAGE_UTILLINUX="@COMMON@""https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.38/util-linux-2.38.tar.xz"

SRC_PACKAGE_LIBELF="@COMMON@""https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz"
SRC_PACKAGE_ELFUTILS="@COMMON@""https://gcc.gnu.org/pub/elfutils/0.189/elfutils-0.189.tar.bz2"

SRC_PACKAGE_LIBFFI="@COMMON@""https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz"
SRC_PACKAGE_LIBXML2="@COMMON@""http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz"
SRC_PACKAGE_XMLEXPAT="@COMMON@""https://github.com/libexpat/libexpat/releases/download/R_2_4_9/expat-2.4.9.tar.xz"
SRC_PACKAGE_LIBYAML="@COMMON@""https://github.com/yaml/libyaml/releases/download/0.2.5/yaml-0.2.5.tar.gz"
SRC_PACKAGE_ZLIB="@COMMON@""https://zlib.net/current/zlib.tar.gz"
SRC_PACKAGE_LZ4="@COMMON@""https://github.com/lz4/lz4/archive/refs/tags/v1.9.4.tar.gz"
SRC_PACKAGE_LIBEVENT="@COMMON@""https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz"

SRC_PACKAGE_LIBCAP="@COMMON@""https://cdn.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.66.tar.xz"

SRC_PACKAGE_HAVEGED="@COMMON@""https://github.com/jirka-h/haveged/archive/refs/tags/v1.9.18.tar.gz"

SRC_PACKAGE_LIBXCRYPT="@COMMON@""https://github.com/besser82/libxcrypt/releases/download/v4.4.36/libxcrypt-4.4.36.tar.xz"

#
# Debug support
#
CUR_PART=${DEBUG_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_GDB="@COMMON@""https://ftp.gnu.org/gnu/gdb/gdb-12.1.tar.xz"
SRC_PACKAGE_STRACE="@COMMON@""https://github.com/strace/strace/releases/download/v6.9/strace-6.9.tar.xz"
#SRC_PACKAGE_LTRACE="@COMMON@""https://fossies.org/linux/misc/ltrace-0.7.3.tar.gz"
SRC_PACKAGE_VALGRIND="@COMMON@""https://sourceware.org/pub/valgrind/valgrind-3.19.0.tar.bz2"

fi

#
# Network support
#

CUR_PART=${NETWORK_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_LIBMNL="@COMMON@""http://netfilter.org/projects/libmnl/files/libmnl-1.0.5.tar.bz2"
SRC_PACKAGE_LIBNFTNL="@COMMON@""https://www.netfilter.org/projects/libnftnl/files/libnftnl-1.2.3.tar.bz2"
SRC_PACKAGE_IPTABLES="@COMMON@""https://www.netfilter.org/projects/iptables/files/iptables-1.8.9.tar.xz"
SRC_PACKAGE_DHCPSERVER="@COMMON@""https://downloads.isc.org/isc/dhcp/4.4.2/dhcp-4.4.2.tar.gz"
#SRC_PACKAGE_DHCPSERVER_PATCH_001="@COMMON@""http://wiki.beyondlogic.org/patches/dhcp-4.3.0b1.bind_arm-linux-gnueabi.patch"
#SRC_PACKAGE_DHCPSERVER_PATCH_002="@COMMON@""http://wiki.beyondlogic.org/patches/bind-9.9.5rc1.gen_crosscompile.patch"
SRC_PACKAGE_LIBPCAP="@COMMON@""https://www.tcpdump.org/release/libpcap-1.10.1.tar.gz"
SRC_PACKAGE_TCPDUMP="@COMMON@""https://www.tcpdump.org/release/tcpdump-4.99.1.tar.gz"
SRC_PACKAGE_TCPSLICE="@COMMON@""https://www.tcpdump.org/release/tcpslice-1.6.tar.gz"
SRC_PACKAGE_IPROUTE2="@COMMON@""https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.0.0.tar.gz"
SRC_PACKAGE_NMAP="@COMMON@""https://nmap.org/dist/nmap-7.93.tar.bz2"
fi

#
# Wireless support
#
CUR_PART=${WIRELESS_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_WIRELESSTOOLS="@COMMON@""https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz"
SRC_PACKAGE_LIBNL3="@COMMON@""https://github.com/thom311/libnl/releases/download/libnl3_7_0/libnl-3.7.0.tar.gz"
SRC_PACKAGE_LIBNL1="@COMMON@""https://www.infradead.org/~tgr/libnl/files/libnl-1.1.4.tar.gz"
SRC_PACKAGE_IW="@COMMON@""https://www.kernel.org/pub/software/network/iw/iw-5.19.tar.xz"
SRC_PACKAGE_WPASUPPLICANT="@COMMON@""https://w1.fi/releases/wpa_supplicant-2.10.tar.gz"
SRC_PACKAGE_HOSTAPD="@COMMON@""https://w1.fi/releases/hostapd-2.10.tar.gz"
SRC_PACKAGE_RFKILL="@COMMON@""https://www.kernel.org/pub/software/network/rfkill/rfkill-1.0.tar.gz"

fi

#
# Services
#
SRC_PACKAGE_GPGERROR="@COMMON@""https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.46.tar.bz2"
SRC_PACKAGE_LIBASSUAN="@COMMON@""https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.5.tar.bz2"
SRC_PACKAGE_GPGME="@COMMON@""https://gnupg.org/ftp/gcrypt/gpgme/gpgme-1.18.0.tar.bz2"
SRC_PACKAGE_OPENSSL="@COMMON@""https://www.openssl.org/source/openssl-3.0.10.tar.gz"
SRC_PACKAGE_OPENSSH="@COMMON@""https://ftp.fr.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.8p1.tar.gz"
SRC_PACKAGE_NTP="@COMMON@""https://downloads.nwtime.org/ntp/ntp-4.2.8p18.tar.gz"
SRC_PACKAGE_CHRONY="@COMMON@""https://chrony-project.org/releases/chrony-4.5.tar.gz"
SRC_PACKAGE_VSFTPD="@COMMON@""https://security.appspot.com/downloads/vsftpd-3.0.5.tar.gz"
SRC_PACKAGE_LIGHTTPD="@COMMON@""https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.67.tar.xz"
#SRC_PACKAGE_CVS=cvs-1.11.23.tar.gz
SRC_PACKAGE_PXESERVER="@COMMON@""https://github.com/jfdelnero/pxe-server/releases/download/PXE_1_4_2/pxe-1.4.2.tar.gz"
SRC_PACKAGE_TFTPD="@COMMON@""https://kernel.googlesource.com/pub/scm/network/tftp/tftp-hpa/+archive/refs/heads/master.tar.gz"
SRC_PACKAGE_UMTPRD="@COMMON@""https://github.com/viveris/uMTP-Responder/archive/refs/tags/umtprd-1.6.2.tar.gz"

SRC_PACKAGE_LIBGMP="@COMMON@""https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz"
SRC_PACKAGE_MAILUTILS="@COMMON@""https://ftp.gnu.org/gnu/mailutils/mailutils-3.15.tar.xz"
SRC_PACKAGE_RIPMIME="@COMMON@""https://github.com/inflex/ripMIME/archive/refs/tags/1.4.1.0.tar.gz"
SRC_PACKAGE_NETTLE="@COMMON@""https://ftp.gnu.org/gnu/nettle/nettle-3.9.1.tar.gz"
SRC_PACKAGE_GNUTLS="@COMMON@""https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.8.tar.xz"
SRC_PACKAGE_MSMTP="@COMMON@""https://marlam.de/msmtp/releases/msmtp-1.8.22.tar.xz"
SRC_PACKAGE_SAMBA="@COMMON@""https://download.samba.org/pub/samba/stable/samba-4.18.6.tar.gz" 

#
# Graphic Stack
#

CUR_PART=${LIBGFX_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_LIBJPEG="@COMMON@""https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/3.0.0.tar.gz"
SRC_PACKAGE_LIBPNG="@COMMON@""https://download.sourceforge.net/libpng/libpng-1.6.38.tar.xz"
SRC_PACKAGE_LIBGD="@COMMON@""https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.xz"
SRC_PACKAGE_FREETYPE="@COMMON@""https://downloads.sourceforge.net/project/freetype/freetype2/2.12.1/freetype-2.12.1.tar.xz"
SRC_PACKAGE_FONTCONFIG="@COMMON@""https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.96.tar.xz"

fi

CUR_PART=${GFX_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

#SRC_PACKAGE_LIBPCIACCESS="@COMMON@""https://www.x.org/archive/individual/lib/libpciaccess-0.16.tar.gz"
SRC_PACKAGE_LIBDRM="@COMMON@""https://dri.freedesktop.org/libdrm/libdrm-2.4.113.tar.xz"

SRC_PACKAGE_DIRECTFB="@COMMON@""https://github.com/Distrotech/DirectFB/archive/DIRECTFB_1_7_7.tar.gz"
SRC_PACKAGE_SDL="@COMMON@""https://www.libsdl.org/release/SDL2-2.0.22.tar.gz"
SRC_PACKAGE_SDL_TTF="@COMMON@""https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.18.tar.gz"
SRC_PACKAGE_SDL_NET="@COMMON@""https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.2.0.tar.gz"

fi

CUR_PART=${GFX3D_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" != "UNDEF" ]
then

SRC_PACKAGE_MESA="@COMMON@""https://mesa.freedesktop.org/archive/mesa-22.2.1.tar.xz"
SRC_PACKAGE_GLEW="@COMMON@""https://downloads.sourceforge.net/project/glew/glew/2.2.0/glew-2.2.0.tgz"
SRC_PACKAGE_GLU="@COMMON@""https://archive.mesa3d.org/glu/glu-9.0.3.tar.xz"
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

SRC_PACKAGE_ALSALIB="@COMMON@""https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.7.2.tar.bz2"
SRC_PACKAGE_ALSAUTILS="@COMMON@""https://www.alsa-project.org/files/pub/utils/alsa-utils-1.2.7.tar.bz2"
SRC_PACKAGE_SDLMIXER="@COMMON@""https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.6.2.tar.gz"
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
SRC_PACKAGE_UTILLINUX="@COMMON@""http://ftp.free.fr/mirrors/ftp.kernel.org/linux/utils/util-linux/v2.36/util-linux-2.36.tar.xz"
SRC_PACKAGE_SYSTEMD="@COMMON@""https://github.com/systemd/systemd/archive/refs/tags/v255.tar.gz"

SRC_PACKAGE_EUDEV="@COMMON@""https://dev.gentoo.org/~blueness/eudev/eudev-3.2.9.tar.gz"
SRC_PACKAGE_LIBINPUT="@COMMON@""https://www.freedesktop.org/software/libinput/libinput-1.17.0.tar.xz"
SRC_PACKAGE_LIBXKBCOMMON="@COMMON@""https://xkbcommon.org/download/libxkbcommon-1.1.0.tar.xz"
SRC_PACKAGE_PIXMAN="@COMMON@""https://cairographics.org/releases/pixman-0.40.0.tar.gz"
SRC_PACKAGE_CAIRO="@COMMON@""https://www.cairographics.org/releases/cairo-1.16.0.tar.xz"
SRC_PACKAGE_LIBPAM="@COMMON@""https://github.com/linux-pam/linux-pam/archive/refs/tags/v1.6.1.tar.gz"
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

SRC_PACKAGE_SDPARM="@COMMON@""https://fossies.org/linux/misc/sdparm-1.12.tgz"
SRC_PACKAGE_HDIDLE="@COMMON@""https://freefr.dl.sourceforge.net/project/hd-idle/hd-idle-1.05.tgz"

fi

#SRC_PACKAGE_PYTHON="@COMMON@""https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tar.xz"
SRC_PACKAGE_PERL="@COMMON@""https://www.cpan.org/src/5.0/perl-5.36.0.tar.xz"
SRC_PACKAGE_PERLCROSS="@COMMON@""https://github.com/arsv/perl-cross/releases/download/1.4/perl-cross-1.4.tar.gz"
SRC_PACKAGE_LIBUSB="@COMMON@""https://github.com/libusb/libusb/releases/download/v1.0.26/libusb-1.0.26.tar.bz2"
#SRC_PACKAGE_LIBUSBGADGET=libusb-gadget.tar.gz

SRC_PACKAGE_LIBNCURSES="@COMMON@""https://ftp.gnu.org/gnu/ncurses/ncurses-6.4.tar.gz"
SRC_PACKAGE_NANOEDITOR="@COMMON@""https://www.nano-editor.org/dist/v8/nano-8.1.tar.xz"
SRC_PACKAGE_LIBAIO="@COMMON@""https://releases.pagure.org/libaio/libaio-0.3.113.tar.gz"

SRC_PACKAGE_LIBCURL="@COMMON@""https://curl.se/download/curl-7.85.0.tar.xz"

SRC_PACKAGE_E2FSPROGS="@COMMON@""https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.46.5/e2fsprogs-1.46.5.tar.xz"
SRC_PACKAGE_EXFATPROGS="@COMMON@""https://github.com/exfatprogs/exfatprogs/releases/download/1.1.3/exfatprogs-1.1.3.tar.gz"

SRC_PACKAGE_USBMODESWITCH="@COMMON@""https://www.draisberghof.de/usb_modeswitch/usb-modeswitch-2.6.0.tar.bz2"

SRC_PACKAGE_FFTW="@COMMON@""https://www.fftw.org/fftw-3.3.10.tar.gz"
SRC_PACKAGE_HACKRF="@COMMON@""https://github.com/greatscottgadgets/hackrf/releases/download/v2022.09.1/hackrf-2022.09.1.tar.xz"

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

#SRC_PACKAGE_PCIUTILS="@COMMON@""https://github.com/pciutils/pciutils/archive/v3.8.0.tar.gz"
#SRC_PACKAGE_FLASHROM="@COMMON@""https://download.flashrom.org/releases/flashrom-1.2.tar.bz2"
#SRC_PACKAGE_FSWEBCAM="@COMMON@""https://www.sanslogic.co.uk/fswebcam/files/fswebcam-20200725.tar.xz"
