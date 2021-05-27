#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Audio stack
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1

source ${TARGET_CONFIG}/config.sh || exit 1

echo "***************"
echo "* Audio stack *"
echo "***************"

####################################################################
# Alsa
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_ALSALIB:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir libalsa
		cd libalsa || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--disable-alsamixer \
				|| exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Alsa Utils
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_ALSAUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir utilsalsa
		cd utilsalsa || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--disable-alsamixer \
				--with-udev-rules-dir=${TARGET_ROOTFS}/lib/udev/rules.d || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# SDL Mixer
####################################################################


CUR_PACKAGE_SDL=${SRC_PACKAGE_SDL:-"UNDEF"}
CUR_PACKAGE_SDL="${CUR_PACKAGE_SDL##*/}"
CUR_PACKAGE=${SRC_PACKAGE_SDLMIXER:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ] && [ "$CUR_PACKAGE_SDL" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir sdlmixer
		cd sdlmixer || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi
