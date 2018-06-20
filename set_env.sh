#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Set env script
#

export TARGET_NAME=${1:-"UNDEF"}

if [ $CROSS_BUILD_SIGN = "CROSS_ENV_SET" ]; then

	echo "*****************************"
	echo "* Environment already set ! *"
	echo "*****************************"

else

	if [ -d "${PWD}/targets/${TARGET_NAME}/config" ]; then

		export BASE_DIR="${PWD}"

		export SCRIPTS_HOME="${BASE_DIR}/scripts/"
		export TARGET_HOME="${BASE_DIR}/targets/${TARGET_NAME}"
		export TARGET_CONFIG="${TARGET_HOME}/config"
		export TARGET_BUILD="${TARGET_HOME}/build"
		export TARGET_SOURCES="${TARGET_HOME}/sources"
		export TARGET_ROOTFS="${TARGET_HOME}/root-fs"
		export TARGET_DOWNLOAD="${TARGET_HOME}/download"
		export TARGET_CROSS_TOOLS="${TARGET_HOME}/cross-tools"

		source ${TARGET_CONFIG}/config.sh

		export CROSS_BUILD_SIGN="CROSS_ENV_SET"


		export PATH="${TARGET_CROSS_TOOLS}/bin:${PATH}:${BASE_DIR}/scripts:"
		export BUILDMACH=$MACHTYPE

		export NBCORE=-j`nproc`

		export PKG_CONFIG_LIBDIR=${TARGET_ROOTFS}/lib/pkgconfig

		clear
		echo "* $TARGET_NAME Environnement set ! *"

		ls *.sh
		echo

		chmod +x ${BASE_DIR}/targets/${TARGET_NAME}/config/*.sh
		chmod +x ${BASE_DIR}/scripts/*.sh
		chmod +x ${BASE_DIR}/*.sh

		cd   ${BASE_DIR}/targets/${TARGET_NAME}

		bash

		echo "*******************************************"
		echo "* You leaved the Cross compil Environment *"
		echo "*******************************************"

		exit 0
	else
		echo "********************"
		echo "* Invalid target ! *"
		echo "********************"

		ls ${PWD}/targets
	fi
fi
