#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Raspberry pi 3 target setup
#

export KERNEL_ARCH=arm64
export TGT_MACH=aarch64-linux
export SSL_ARCH=linux-aarch64
export GCC_ADD_CONF="--enable-fix-cortex-a53-843419"

export KERNEL_IMAGE_TYPE="Image"


# Kernel

SRC_PACKAGE_KERNEL=raspberrypi-kernel_1.20171029-1.tar.gz

# System base + Cross compiler

SRC_PACKAGE_BINUTILS=binutils-2.28.tar.gz

SRC_PACKAGE_GCC=gcc-6.4.0.tar.gz
SRC_PACKAGE_GCC_MPFR=mpfr-3.1.2.tar.xz
SRC_PACKAGE_GCC_GMP=gmp-6.0.0a.tar.xz
SRC_PACKAGE_GCC_MPC=mpc-1.0.3.tar.gz
SRC_PACKAGE_GCC_ISL=isl-0.15.tar.bz2
SRC_PACKAGE_GCC_CLOOG=cloog-0.18.1.tar.gz

SRC_PACKAGE_GLIBC=glibc-2.25.tar.xz

SRC_PACKAGE_BUSYBOX=busybox-1.27.2.tar.bz2

#SRC_PACKAGE_LIBFFI=libffi-3.2.tar.gz
SRC_PACKAGE_LIBXML2=libxml2-2.9.7.tar.gz
SRC_PACKAGE_XMLEXPAT=expat-2.2.5.tar.bz2
SRC_PACKAGE_ZLIB=zlib-1.2.11.tar.gz
SRC_PACKAGE_LIBEVENT=libevent-2.1.8-stable.tar.gz

# Debug support
SRC_PACKAGE_GDB=gdb-8.0.1.tar.gz
SRC_PACKAGE_STRACE=strace-4.20.tar.xz

# Network support
SRC_PACKAGE_LIBMNL=libmnl-1.0.4.tar.bz2
SRC_PACKAGE_LIBNFTNL=libnftnl-1.0.9.tar.bz2
SRC_PACKAGE_IPTABLES=iptables-1.6.1.tar.bz2

# Wireless support
SRC_PACKAGE_WIRELESSTOOLS=wireless_tools.29.tar.gz
SRC_PACKAGE_LIBNL3=libnl-3.2.25.tar.gz
SRC_PACKAGE_LIBNL1=libnl-1.1.4.tar.gz
SRC_PACKAGE_IW=iw-4.14.tar.gz
SRC_PACKAGE_WPASUPPLICANT=wpa_supplicant-2.6.tar.gz
SRC_PACKAGE_HOSTAPD=hostapd-2.6.tar.gz
SRC_PACKAGE_RFKILL=rfkill-0.5.tar.gz

# Services
SRC_PACKAGE_OPENSSL=openssl-1.0.2n.tar.gz
SRC_PACKAGE_OPENSSH=openssh-7.3p1.tar.gz
SRC_PACKAGE_NTP=ntp-4.2.8p10.tar.gz
SRC_PACKAGE_VSFTPD=vsftpd-3.0.3.tar.gz
#SRC_PACKAGE_CVS=cvs-1.11.23.tar.gz

# Graphic Stack
SRC_PACKAGE_LIBDRM=libdrm-2.4.88.tar.gz
SRC_PACKAGE_MESA=mesa-17.3.1.tar.gz
SRC_PACKAGE_GLEW=glew-2.1.0.tgz
SRC_PACKAGE_GLU=glu-9.0.0.tar.gz
#SRC_PACKAGE_GLUT=glut.tar.gz

SRC_PACKAGE_FREETYPE=freetype-2.8.1.tar.bz2
SRC_PACKAGE_FONTCONFIG=fontconfig-2.12.4.tar.bz2
SRC_PACKAGE_DIRECTFB=DirectFB-1.7.7.tar.gz
#SRC_PACKAGE_SDL=SDL2-2.0.7.tar.gz
#SRC_PACKAGE_SDL_TTF=SDL2_ttf-2.0.14.tar.gz
