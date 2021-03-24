#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# system librairies
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1

source ${TARGET_CONFIG}/config.sh || exit 1

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
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD}
		mkdir zlib
		cd zlib || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					|| exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

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
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir expat
		cd expat || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--without-docbook \
				CC=${TGT_MACH}-gcc || exit 1

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

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
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir ncurses
		cd ncurses || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				--disable-stripping STRIPPROG=${TGT_MACH}-strip \
				--with-curses-h \
				--enable-pc-files \
				--with-pkg-config-libdir=${TARGET_ROOTFS}/lib/pkgconfig || exit 1

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

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
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir libxml2
		cd libxml2 || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH \
					CC=${TGT_MACH}-gcc \
					--without-python || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

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
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

		if [ -f ${TARGET_CONFIG}/patchs/ffi.patch ]
		then
		(
			cd src/aarch64 || exit 1
			patch -Zf < ${TARGET_CONFIG}/patchs/ffi.patch  || exit 1
		) || exit 1
		fi

		cd ${TARGET_BUILD} || exit 1
		mkdir libffi
		cd libffi || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
					--host=$TGT_MACH \
					--prefix="${TARGET_ROOTFS}" || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBGMP
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBGMP:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir libnettle
		cd libnettle || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# NETTLE
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_NETTLE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir libnettle
		cd libnettle || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# GnuTLS
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GNUTLS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir libgnutls
		cd libgnutls || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH \
					--with-included-libtasn1 \
					--with-included-unistring \
					--without-p11-kit || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

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
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}  || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/Configure \
				${SSL_ARCH} shared --prefix="${TARGET_ROOTFS}" || exit 1

		make || exit 1
		make install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

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
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir libevent
		cd libevent || exit 1


		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
					--host=$TGT_MACH \
					--prefix="${TARGET_ROOTFS}" || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi
