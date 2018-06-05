#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# system librairies
#

source ${BASE_DIR}/scripts/unpack.sh || exit 1

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

echo "****************"
echo "*  Librairies  *"
echo "****************"

####################################################################
# ZLIB
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_ZLIB:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/$TARGET_NAME
		mkdir zlib
		cd zlib || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure --prefix="${TARGET_ROOTFS}" || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# XML EXPAT
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_XMLEXPAT:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/$TARGET_NAME || exit 1
		mkdir expat
		cd expat || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure --prefix="${TARGET_ROOTFS}" --host=$TGT_MACH CC=${TGT_MACH}-gcc || exit 1

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# NCURSES
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBNCURSES:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/$TARGET_NAME || exit 1
		mkdir ncurses
		cd ncurses || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure --prefix="${TARGET_ROOTFS}" --host=$TGT_MACH CC=${TGT_MACH}-gcc --disable-stripping STRIPPROG=${TGT_MACH}-strip --with-curses-h || exit 1

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBXML
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBXML2:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/$TARGET_NAME || exit 1
		mkdir libxml2
		cd libxml2 || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure --prefix="${TARGET_ROOTFS}" --host=$TGT_MACH CC=${TGT_MACH}-gcc --without-python || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBFFI
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBFFI:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		if [ -f ${BASE_DIR}/configs/${TARGET_NAME}/patchs/ffi.patch ]
		then
		(
			cd src/aarch64 || exit 1
			patch -Zf < ${BASE_DIR}/configs/${TARGET_NAME}/patchs/ffi.patch  || exit 1
		) || exit 1
		fi

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir libffi
		cd libffi || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure  --host=$TGT_MACH --prefix="${TARGET_ROOTFS}" || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# OpenSSL
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_OPENSSL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/$TARGET_NAME/${TMP_ARCHIVE_FOLDER}  || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		export PKG_CONFIG_LIBDIR=${TARGET_ROOTFS}/lib/pkgconfig

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/Configure ${SSL_ARCH} shared --prefix="${TARGET_ROOTFS}" || exit 1

		make || exit 1
		make install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LibEvent
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBEVENT:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/$TARGET_NAME
		mkdir libevent
		cd libevent || exit 1

		export PKG_CONFIG_LIBDIR=${TARGET_ROOTFS}/lib/pkgconfig

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure --host=$TGT_MACH --prefix="${TARGET_ROOTFS}" || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

