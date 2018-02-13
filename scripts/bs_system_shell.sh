#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# System shell and tools
#

source ${BASE_DIR}/scripts/unpack.sh || exit 1

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

echo "*********************************"
echo "*   System shell and tools...   *"
echo "*********************************"

####################################################################
# Busybox
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUSYBOX:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/${TARGET_NAME} || exit 1
		mv ${TMP_ARCHIVE_FOLDER} busybox
		cd busybox || exit 1

		make ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}-  defconfig || exit 1
		#make ${NBCORE}  ARCH=${KERNEL_ARCH}  CROSS_COMPILE=${TGT_MACH}-  menuconfig || exit 1
		cp ${BASE_DIR}/configs/${TARGET_NAME}/busybox_config .config || exit 1

		make ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}-  || exit 1
		make ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}-  install CONFIG_PREFIX=${TARGET_ROOTFS} || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Util Linux
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_UTILLINUX:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/$TARGET_NAME
		mkdir util-linux
		cd util-linux || exit 1

		#export CC=${TGT_MACH}-gcc
		#export LD=${TGT_MACH}-ld
		#export AS=${TGT_MACH}-as
		#export AR=${TGT_MACH}-ar
		export INSTALLDIR=${TARGET_ROOTFS}

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure --prefix="${TARGET_ROOTFS}" --host=$TGT_MACH \
						--disable-all-programs \
						--enable-mount \
						--enable-libmount \
						--enable-libblkid \
						--with-bashcompletiondir=${TARGET_ROOTFS}/usr/share/bash-completion/completions/ \
						--disable-makeinstall-chown \
						--disable-makeinstall-setuid \
						|| exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi
