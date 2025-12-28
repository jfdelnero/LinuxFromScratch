#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# i686-pc setup
#

export KERNEL_ARCH=x86_64
export TGT_MACH=x86_64-UNREG-linux
export SSL_ARCH=linux-generic64
export GCC_ADD_CONF=""

export TARGET_BUILD_SUPPORT="1"

export KERNEL_IMAGE_TYPE="bzImage"
export KERNEL_FIRMWARES="YES"

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

export HDD_SUPPORT="1"
export NETWORK_STATION_MODE="1"
#export NETWORK_ROUTER_MODE="1"

SRC_PACKAGE_PCIUTILS="@COMMON@""https://github.com/pciutils/pciutils/releases/download/v3.13.0/pciutils-3.13.0.tar.gz"
SRC_PACKAGE_LIBPCIACCESS="https://www.x.org/archive/individual/lib/libpciaccess-0.14.tar.gz"
SRC_PACKAGE_GRUB="https://ftpmirror.gnu.org/gnu/grub/grub-2.12.tar.xz"
SRC_PACKAGE_GRUB_BIOS="https://ftpmirror.gnu.org/gnu/grub/grub-2.12.tar.xz"
SRC_PACKAGE_GRUB_EFI="https://ftpmirror.gnu.org/gnu/grub/grub-2.12.tar.xz"

#SRC_PACKAGE_SYSLINUX="https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz"
#SRC_PACKAGE_LILO=https://www.joonet.de/sources/lilo/lilo-24.2.tar.gz

# Kernel

SRC_PACKAGE_KERNEL="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.12.9.tar.xz"

SRC_PACKAGE_DIRECTFB=
SRC_PACKAGE_PYTHON=
