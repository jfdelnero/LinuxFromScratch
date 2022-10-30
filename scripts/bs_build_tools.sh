#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Local build tools
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1

source ${TARGET_CONFIG}/config.sh || exit 1

echo "*******************"
echo "*   Build Tools   *"
echo "*******************"

####################################################################
# Gperf (Re)build
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_GPERF:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "******************"
		echo "*  Local Gperf   *"
		echo "******************"

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv gperf_local
		cd gperf_local || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${TARGET_CROSS_TOOLS}" \
				--exec-prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make all install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# LIBFFI
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBFFI:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

		cd ${TARGET_BUILD} || exit 1
		mkdir libffi_local
		cd libffi_local || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--datarootdir="${TARGET_CROSS_TOOLS}" \
				--exec-prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# XML EXPAT
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_XMLEXPAT:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TARGET_BUILD} || exit 1
		mkdir expat_local
		cd expat_local || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--without-docbook \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--datarootdir="${TARGET_CROSS_TOOLS}" \
				--exec-prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBXML
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBXML2:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TARGET_BUILD} || exit 1
		mkdir libxml2_local
		cd libxml2_local || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_CROSS_TOOLS}" \
					--datarootdir="${TARGET_CROSS_TOOLS}" \
					--exec-prefix="${TARGET_CROSS_TOOLS}" \
					--without-python || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# CMAKE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_CMAKE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

		cd ${TARGET_BUILD} || exit 1
		mkdir cmake_local
		cd cmake_local || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# MAKE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_MAKE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

		cd ${TARGET_BUILD} || exit 1
		mkdir make_local
		cd make_local || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# heimdal
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_HEIMDAL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir heimdal
		cd heimdal || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--disable-shared \
				--enable-static \
				--without-openldap \
				--without-capng \
				--with-db-type-preference= \
				--without-sqlite3 \
				--without-libintl \
				--without-openssl \
				--without-berkeley-db \
				--without-readline \
				--without-libedit \
				--without-hesiod \
				--without-x \
				--disable-mdb-db \
				--disable-ndbm-db \
				--disable-heimdal-documentation || exit 1

		make ${NBCORE} || exit 1
		make ${NBCORE} install || exit 1

		cp ./lib/com_err/compile_et ${TARGET_CROSS_TOOLS}/bin
		cp -a ./lib/com_err/.libs ${TARGET_CROSS_TOOLS}/bin

		ln -sf ${TARGET_CROSS_TOOLS}/libexec/heimdal/asn1_compile	${TARGET_CROSS_TOOLS}/bin/asn1_compile
		ln -sf ${TARGET_CROSS_TOOLS}/bin/compile_et ${TARGET_CROSS_TOOLS}/libexec/heimdal/compile_et

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

