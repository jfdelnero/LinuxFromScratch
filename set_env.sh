#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Set env script
#

CROSS_BUILD_SIGN=${CROSS_BUILD_SIGN:-"UNDEF"}
if [ $CROSS_BUILD_SIGN = "CROSS_ENV_SET" ]; then

	echo "***********************************"
	echo "* Build environment already set ! *"
	echo "***********************************"
	echo
	echo "Current build environment :" ${TARGET_NAME}
	echo "use the command exit to leave this build environment."
	echo
else
	export TARGET_NAME=${1:-"UNDEF"}

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

		echo "*****************************************************"
		echo "* $TARGET_NAME Environment set !"
		echo "* Commands:"
		echo "* sysbuild.sh : Build the whole target system."
		echo "* init_sd.sh  : Copy the root-fs to the flash media."
		echo "* clean.sh    : Delete built objects and root-fs."
		echo "*****************************************************"
		echo

		chmod +x ${BASE_DIR}/targets/${TARGET_NAME}/config/*.sh
		chmod +x ${BASE_DIR}/scripts/*.sh
		chmod +x ${BASE_DIR}/*.sh

		cd   ${BASE_DIR}/targets/${TARGET_NAME}

		echo "Current folder :"
		pwd
		echo

		bash

		echo "************************************************************"
		echo "* You just leaved the " ${TARGET_NAME} " build Environment"
		echo "************************************************************"

		exit 0
	else
		echo "********************"
		echo "* Invalid target ! *"
		echo "********************"
		echo
		echo "Please specify one of these available targets :"
		echo
		ls ${PWD}/targets
		echo
	fi
fi
