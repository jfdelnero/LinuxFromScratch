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

	if [ -d "${PWD}/configs/${TARGET_NAME}" ]; then

		export CROSS_BUILD_SIGN="CROSS_ENV_SET"

		export TARGET_ROOTFS="${PWD}/targets/${TARGET_NAME}/root-fs"
		export CROSS_COMPILER_TOOLS="${TARGET_ROOTFS}/cross-tools"

		export BASE_DIR="${PWD}"

		source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh

		export PATH="${PATH}:${CROSS_COMPILER_TOOLS}/bin"
		export BUILDMACH=$MACHTYPE

		export NBCORE=-j`nproc`

		clear
		echo "* $TARGET_NAME Environnement set ! *"

		ls *.sh
		echo

		bash

		echo "*******************************************"
		echo "* You leaved the Cross compil Environment *"
		echo "*******************************************"

		exit 0
	else
		echo "********************"
		echo "* Invalid target ! *"
		echo "********************"

		ls ${PWD}/configs
	fi
fi
