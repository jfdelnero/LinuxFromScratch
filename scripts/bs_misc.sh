#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Miscellaneous stuffs
#

source ${BASE_DIR}/scripts/unpack.sh || exit 1

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

echo "*********************"
echo "*   Miscellaneous   *"
echo "*********************"

####################################################################
# SDPARM
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SDPARM:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir sdparm
		cd sdparm || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# HDIDLE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_HDIDLE:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		export CROSS=${TGT_MACH}
		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar
		export TARGET_DIR=${TARGET_ROOTFS}

		cat "Makefile" | sed s#-g\ root\ -o\ root##g > "Makefile_new" || exit 1
		cp Makefile_new Makefile

		make ${NBCORE}          || exit 1
		make ${NBCORE} install  || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# PCI UTILS
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_PCIUTILS:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		make ${NBCORE} CROSS_COMPILE=${TGT_MACH}- PREFIX=${TARGET_ROOTFS} || exit 1
		make ${NBCORE} CROSS_COMPILE=${TGT_MACH}- PREFIX=${TARGET_ROOTFS} STRIP="-s --strip-program=${TGT_MACH}-strip"  install  || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# PYTHON
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_PYTHON:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1

		mkdir python
		cd python || exit 1

		echo ac_cv_file__dev_ptmx=no > ./config.site
		echo ac_cv_file__dev_ptc=no >> ./config.site
		export CONFIG_SITE=config.site

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix= \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--disable-ipv6 \
				--enable-shared \
				|| exit 1

		make ${NBCORE} || exit 1
		make ${NBCORE} altinstall DESTDIR=${TARGET_ROOTFS} || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBAIO
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBAIO:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		make ${NBCORE} prefix=${TARGET_ROOTFS} || exit 1
		make ${NBCORE} prefix=${TARGET_ROOTFS} install  || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBUSB
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBUSB:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir libusb
		cd libusb || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBUSB Gadget
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBUSBGADGET:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir libusbgadget
		cd libusbgadget || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Nano
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_NANOEDITOR:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir nano
		cd nano || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${NBCORE} CFLAGS="-I/${TARGET_ROOTFS}/include/ncurses" CPPFLAGS="-I${TARGET_ROOTFS}/include/ncurses"       || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Mame
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_MAME:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		export PKG_CONFIG_PATH=${TARGET_ROOTFS}/lib/pkgconfig

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		# Mame hack :
		export MARVELL_SDK_PATH="${CROSS_COMPILER_TOOLS}"
		export MARVELL_ROOTFS="${TARGET_ROOTFS}"

		make steamlink REGENIE=1 SOURCES=src/mame/drivers/pacman.cpp -j3  NO_USE_MIDI=1 NO_X11=1 || exit 1

		mkdir ${TARGET_ROOTFS}/mame
		cp mame ${TARGET_ROOTFS}/mame || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

