#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# SD init (to rework...)
#

CROSS_BUILD_SIGN=${CROSS_BUILD_SIGN:-"UNDEF"}

if [ $CROSS_BUILD_SIGN != "CROSS_ENV_SET" ]; then

echo "*******************************"
echo "*    Environment not set !    *"
echo "*   Please call set_env.sh    *"
echo "*******************************"

exit 2

fi

source ${TARGET_CONFIG}/config.sh || exit 1

STRIPPARAM=$2
ROOTFS_STRIP=${STRIPPARAM:-"UNDEF"}
ROOTFS_STRIP="${ROOTFS_STRIP##*/}"

##########################################################################
# Duplicate root fs
##########################################################################

export TARGET_ROOTFS_MIRROR=${TARGET_HOME}/fs_mirror

rm -Rf ${TARGET_ROOTFS_MIRROR}

mkdir  ${TARGET_ROOTFS_MIRROR}
cd     ${TARGET_ROOTFS_MIRROR}

cp -av ${TARGET_ROOTFS}/* .

##########################################################################
# Strip the whole root fs !
##########################################################################

rm -R bin/ld bin/ld.bfd bin/as bin/objdump bin/strip bin/ar bin/ranlib bin/nm bin/readelf bin/omshell
rm -R man
rm -R ssl
rm -R share/man
rm -R share/doc
rm -R share/gtk-doc
rm -R share/locale/*
rm -R share/info/*
rm -R share/i18n

CUR_PART=${TARGET_BUILD_SUPPORT:-"UNDEF"}
if [ "$CUR_PART" == "UNDEF" ]
then
(
	rm -R include

	find ./lib -type f -name "*.la" -delete
	find ./lib -type f -name "*.a" -delete
	find ./lib64 -type f -name "*.la" -delete
	find ./lib64 -type f -name "*.a" -delete
)
fi

if [ "$ROOTFS_STRIP" != "NOSTRIP" ]
then
(
	echo "*******************************"
	echo "*    Stripping Binaries...    *"
	echo "*******************************"

	find ./ -type f -print0  -print | xargs -0 ${TGT_MACH}-strip --strip-debug --strip-unneeded

	find ./bin   -type f -exec ${TGT_MACH}-strip --strip-debug --strip-unneeded {} \;
	find ./lib   -type f -exec ${TGT_MACH}-strip --strip-debug --strip-unneeded {} \;
	find ./lib64 -type f -exec ${TGT_MACH}-strip --strip-debug --strip-unneeded {} \;
	find ./sbin  -type f -exec ${TGT_MACH}-strip --strip-debug --strip-unneeded {} \;
	find ./usr   -type f -exec ${TGT_MACH}-strip --strip-debug --strip-unneeded {} \;
)
fi

rm ./bin/smbd/*.old
rm ./bin/smbclient/*.old

# Fix buggy path...
gcc ${BASE_DIR}/scripts/fix_bin_paths.c -o ${BASE_DIR}/scripts/fix_bin_paths

find ./ -type f -exec ${BASE_DIR}/scripts/fix_bin_paths {} ${TARGET_ROOTFS} \;

##########################################################################
# Copy configs files and do some last fixes...
##########################################################################

chmod +x "./lib/libc.so" || exit 1
chmod +x "./lib/libpthread.so" || exit 1

cp -R ${COMMON_CONFIG}/rootfs_cfg/* ./
cp -R ${TARGET_CONFIG}/rootfs_cfg/* ./

chmod +x ./etc/init.d/rcS
chmod +x ./etc/rcS.d/*

chmod +x ./usr/share/udhcpc/*
chmod go-rxw ./etc/ssh/ssh_host_*

mkdir home/anonymous
mkdir home/root
mkdir ramdisk
mkdir mnt/tmp
mkdir usr/share/empty

CUR_PACKAGE=${SRC_PACKAGE_PXESERVER:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" == "UNDEF" ]
then
(
	rename 's/pxe\.sh$/pxe\.dis/' ./etc/rcS.d/*.sh
)
fi

CUR_PACKAGE=${SRC_PACKAGE_WPASUPPLICANT:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" == "UNDEF" ]
then
(
	rename 's/wireless\.sh$/wireless\.dis/' ./etc/rcS.d/*.sh
)
fi

CUR_PACKAGE=${SRC_PACKAGE_VSFTPD:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" == "UNDEF" ]
then
(
	rename 's/vsftpd\.sh$/vsftpd\.dis/' ./etc/rcS.d/*.sh
)
fi

CUR_PACKAGE=${SRC_PACKAGE_LIGHTTPD:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" == "UNDEF" ]
then
(
	rename 's/lighttpd\.sh$/lighttpd\.dis/' ./etc/rcS.d/*.sh
)
fi

CUR_PACKAGE=${SRC_PACKAGE_SAMBA:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" == "UNDEF" ]
then
(
	rename 's/samba\.sh$/samba\.dis/' ./etc/rcS.d/*.sh
)
fi

CUR_PACKAGE=${SRC_PACKAGE_OPENSSH:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" == "UNDEF" ]
then
(
	rename 's/ssh\.sh$/ssh\.dis/' ./etc/rcS.d/*.sh
)
fi

TMP_VAR=${NETWORK_ROUTER_MODE:-"UNDEF"}
if [ "$TMP_VAR" == "UNDEF" ]
then
(
	rename 's/network_router\.sh$/network_router\.dis/' ./etc/rcS.d/*.sh
)
fi

TMP_VAR=${NETWORK_STATION_MODE:-"UNDEF"}
if [ "$TMP_VAR" == "UNDEF" ]
then
(
	rename 's/network_station\.sh$/network_station\.dis/' ./etc/rcS.d/*.sh
)
fi

##########################################################################
# Post process install...
##########################################################################

if [ -f ${TARGET_CONFIG}/install_post_process.sh ]
then
(
	echo Post install script available...
	${TARGET_CONFIG}/install_post_process.sh || exit 1
)
fi

##########################################################################
# Copy to Flash media !
##########################################################################

cd ..

if [ ! -f $1 ]; then
    echo "Copy to Flash media ..."

    sudo umount $1

    sudo mkfs.ext4 $1

    mkdir mount_point

    sudo mount $1 mount_point || exit 1

    cd mount_point

    sudo cp -av ${TARGET_ROOTFS_MIRROR}/* .

    sudo chown -R root *
    sudo chgrp -R root *

    sudo chmod ugo-w home
    sudo chmod +x etc/*.sh
    sudo chmod +x etc/rcS.d/*.sh
    sudo chmod go-w etc/*.sh
    sudo chmod go-w etc/rcS.d/*.sh
    sudo chmod go-w etc/*
    sudo chmod ugo-rwx etc/passwd
    sudo chmod u+rw etc/passwd
    sudo chmod go+r etc/passwd

    cd ..

    sudo umount $1
fi

echo  Done !

