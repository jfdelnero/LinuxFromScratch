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
