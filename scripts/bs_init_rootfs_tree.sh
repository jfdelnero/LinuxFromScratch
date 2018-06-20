#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# ROOT FS Init script
#

mkdir -p ${TARGET_ROOTFS}               || exit 1
mkdir -p ${TARGET_CROSS_TOOLS}          || exit 1

mkdir -p ${TARGET_ROOTFS}               || exit 1
mkdir -p ${TARGET_ROOTFS}/bin           || exit 1
mkdir -p ${TARGET_ROOTFS}/boot          || exit 1
mkdir -p ${TARGET_ROOTFS}/dev           || exit 1
mkdir -p ${TARGET_ROOTFS}/var           || exit 1
mkdir -p ${TARGET_ROOTFS}/etc           || exit 1
mkdir -p ${TARGET_ROOTFS}/etc/init.d    || exit 1
mkdir -p ${TARGET_ROOTFS}/home          || exit 1
mkdir -p ${TARGET_ROOTFS}/home/www      || exit 1
mkdir -p ${TARGET_ROOTFS}/media         || exit 1
mkdir -p ${TARGET_ROOTFS}/mnt           || exit 1
mkdir -p ${TARGET_ROOTFS}/opt           || exit 1
mkdir -p ${TARGET_ROOTFS}/proc          || exit 1
mkdir -p ${TARGET_ROOTFS}/root          || exit 1
mkdir -p ${TARGET_ROOTFS}/run           || exit 1
mkdir -p ${TARGET_ROOTFS}/lib           || exit 1
mkdir -p ${TARGET_ROOTFS}/lib64         || exit 1
mkdir -p ${TARGET_ROOTFS}/srv           || exit 1
mkdir -p ${TARGET_ROOTFS}/sbin          || exit 1
mkdir -p ${TARGET_ROOTFS}/sys           || exit 1
mkdir -p ${TARGET_ROOTFS}/tmp           || exit 1
mkdir -p ${TARGET_ROOTFS}/usr           || exit 1
mkdir -p ${TARGET_ROOTFS}/usr/lib       || exit 1
mkdir -p ${TARGET_ROOTFS}/usr/include   || exit 1
mkdir -p ${TARGET_ROOTFS}/var           || exit 1
mkdir -p ${TARGET_ROOTFS}/var/db        || exit 1

echo "************************************"
echo "*   Basic ROOT FS tree generated   *"
echo "************************************"

exit 0
