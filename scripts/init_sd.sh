#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# SD init (to rework...)
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

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

echo "*************************"
echo "*    Preparing image    *"
echo "*************************"

##########################################################################
# Duplicate root fs
##########################################################################

create_tmprootfs_dir || exit 1

cd ${TARGET_ROOTFS_MIRROR} || exit 1

echo Copying files to temporary root fs ...

cp -a ${TARGET_ROOTFS}/* .

##########################################################################
# Strip the whole root fs !
##########################################################################

echo Cleaning / striping the temporary root fs ...

rm -R bin/ld bin/ld.bfd bin/as bin/objdump bin/strip bin/ar bin/ranlib bin/nm bin/readelf bin/omshell 2> /dev/null
rm -R man 2> /dev/null
rm -R ssl 2> /dev/null
rm -R share/man 2> /dev/null
rm -R share/doc 2> /dev/null
rm -R share/gtk-doc 2> /dev/null
rm -R share/locale/* 2> /dev/null
rm -R share/info/* 2> /dev/null
rm -R share/i18n 2> /dev/null

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
	echo "Stripping Binaries..."

	find ./ -type f -print0  -print | xargs -0 ${TGT_MACH}-strip --strip-debug --strip-unneeded 2> /dev/null
 
	find ./bin   -type f -exec ${TGT_MACH}-strip --strip-debug --strip-unneeded {} \; 2> /dev/null
	find ./lib   -type f -exec ${TGT_MACH}-strip --strip-debug --strip-unneeded {} \; 2> /dev/null
	find ./lib64 -type f -exec ${TGT_MACH}-strip --strip-debug --strip-unneeded {} \; 2> /dev/null
	find ./sbin  -type f -exec ${TGT_MACH}-strip --strip-debug --strip-unneeded {} \; 2> /dev/null
	find ./usr   -type f -exec ${TGT_MACH}-strip --strip-debug --strip-unneeded {} \; 2> /dev/null
)
fi

rm ./bin/smbd/*.old 2> /dev/null
rm ./bin/smbclient/*.old 2> /dev/null

echo Fixing bad built-in paths...

# Fix bad paths...
gcc ${BASE_DIR}/scripts/fix_bin_paths.c -o ${BASE_DIR}/scripts/fix_bin_paths 

find ./ -type f -exec ${BASE_DIR}/scripts/fix_bin_paths {} ${TARGET_ROOTFS} \; > /dev/null

##########################################################################
# Copy configs files and do some last fixes...
##########################################################################

chmod +x "./lib/*.so" 2> /dev/null

cp -R ${COMMON_CONFIG}/rootfs_cfg/* ./
cp -R ${TARGET_CONFIG}/rootfs_cfg/* ./

mkdir home/anonymous
mkdir home/root
mkdir ramdisk
mkdir mnt/tmp
mkdir usr/share/empty
mkdir etc/samba/private
mkdir etc/samba/private/msg.sock

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

# Fix scripts carriage returns
find ./etc/ -type f -name "*.sh" -exec dos2unix {} \; 2> /dev/null

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

	${SCRIPTS_HOME}/fix_fs_perm.sh

	cd ..

	sudo umount $1
fi

delete_tmprootfs_dir

echo  Done !

