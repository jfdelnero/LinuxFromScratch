#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# SD init (to rework...)
#

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

CROSS_BUILD_SIGN=${CROSS_BUILD_SIGN:-"UNDEF"}

if [ $CROSS_BUILD_SIGN != "CROSS_ENV_SET" ]; then

echo "*******************************"
echo "*    Environment not set !    *"
echo "*   Please call set_env.sh    *"
echo "*******************************"

exit 2

fi

echo $1

gcc scripts/fix_bin_paths.c -o scripts/fix_bin_paths

rm -R sd_mirror

mkdir sd_mirror

cd sd_mirror/
rm -Rf *
cp -av ${TARGET_ROOTFS}/* .

find . -type f -exec ../scripts/fix_bin_paths {} ${TARGET_ROOTFS} \;

chmod +x "./lib/libc.so" || exit 1
chmod +x "./lib/libpthread.so" || exit 1

cp -R ${BASE_DIR}/configs/${TARGET_NAME}/rootfs_cfg/bin/* ./bin/
cp -R ${BASE_DIR}/configs/${TARGET_NAME}/rootfs_cfg/etc/* ./etc/
cp -R ${BASE_DIR}/configs/${TARGET_NAME}/rootfs_cfg/usr/* ./usr/

chmod +x ./etc/init.d/rcS
chmod +x ./usr/share/udhcpc/*
chmod go-rxw ./etc/ssh_host_rsa_key

mkdir ramdisk
mkdir mnt/tmp
mkdir usr/share/empty

chown -R root:root ./*

#Strip
rm -R bin/ld bin/ld.bfd bin/as bin/objdump bin/strip bin/ar bin/ranlib bin/nm bin/readelf bin/omshell
rm -R man
rm -R ssl
rm -R share/man
rm -R share/locale/*
rm -R share/info/*
rm -R share/i18n
rm -R include

# Post process install...

if [ -f ${BASE_DIR}/configs/${TARGET_NAME}/install_post_process.sh ]
then
(
	echo Post install script available...
	${BASE_DIR}/configs/${TARGET_NAME}/install_post_process.sh || exit 1
)
fi


# Copy to SD
cd ..

umount $1

mkfs.ext4 $1

mkdir mount_point

mount $1 mount_point || exit 1

cd mount_point

cp -av ../sd_mirror/* .

cd ..

umount $1

echo done...
