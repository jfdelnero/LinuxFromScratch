#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# i686-pc setup
#

export KERNEL_ARCH=x86
export TGT_MACH=i686-linux
export SSL_ARCH=linux-generic32
export GCC_ADD_CONF=""

export KERNEL_IMAGE_TYPE=""

export DEBUG_SUPPORT="1"
export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"
export GFX_SUPPORT="1"
#export WAYLAND_SUPPORT="1"
export AUDIO_SUPPORT="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

export MESA_DRI_DRV="i915,i965,nouveau,radeon,r200,swrast"
export MESA_GALLIUM_DRV="i915,nouveau,r600,svga,swrast"

export DRM_SUPPORT="--enable-intel --enable-radeon --enable-amdgpu --enable-nouveau"

SRC_PACKAGE_LIBPCIACCESS="https://www.x.org/archive/individual/lib/libpciaccess-0.14.tar.gz"
SRC_PACKAGE_GRUB="https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz"
SRC_PACKAGE_GRUB_BIOS="https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz"
SRC_PACKAGE_GRUB_EFI="https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz"

#SRC_PACKAGE_SYSLINUX="https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz"
#SRC_PACKAGE_LILO=https://www.joonet.de/sources/lilo/lilo-24.2.tar.gz

# Kernel

SRC_PACKAGE_KERNEL="https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.325.tar.xz"

SRC_PACKAGE_DIRECTFB=
SRC_PACKAGE_PYTHON=
