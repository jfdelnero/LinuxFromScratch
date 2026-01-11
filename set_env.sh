#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
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

		export BUILDTOOLS_HOME="${BASE_DIR}/build-tools/"
		export BUILDTOOLS_CONFIG="${BUILDTOOLS_HOME}/config"
		export BUILDTOOLS_BUILD="${BUILDTOOLS_HOME}/build"

		export COMMON_HOME="${BASE_DIR}/targets/common"
		export COMMON_CONFIG="${COMMON_HOME}/config"
		export COMMON_PATCHES="${COMMON_HOME}/patches"
		export COMMON_DOWNLOAD="${COMMON_HOME}/download"

		# uncomment these lines to use shm/ramdisk as a temporary build folder
		# (require >= 32GB of RAM) 
		#export BUILD_MODE="BUILD_MODE_SHM"
		#export BUILD_TMP_OBJ_BASEFOLDER="/dev/shm"

		export MAKE_FLAGS="-s"

		if [ -z "$LD_LIBRARY_PATH" ]; then
			export LD_LIBRARY_PATH=${BUILDTOOLS_HOME}/lib:${BUILDTOOLS_HOME}/lib64:${TARGET_CROSS_TOOLS}/lib:${TARGET_CROSS_TOOLS}/lib64:${BUILDTOOLS_HOME}/opt/gccgo/lib64
		else
			export LD_LIBRARY_PATH=${BUILDTOOLS_HOME}/lib:${BUILDTOOLS_HOME}/lib64:${TARGET_CROSS_TOOLS}/lib:${TARGET_CROSS_TOOLS}/lib64:${BUILDTOOLS_HOME}/opt/gccgo/lib64:${LD_LIBRARY_PATH}
		fi

		export PATH="${BUILDTOOLS_HOME}/bin:${BUILDTOOLS_HOME}/usr/bin:${BUILDTOOLS_HOME}/sbin:${TARGET_CROSS_TOOLS}/bin:${TARGET_CROSS_TOOLS}/usr/bin:${TARGET_CROSS_TOOLS}/sbin:${BUILDTOOLS_HOME}/opt/go/bin:${PATH}:${BASE_DIR}/scripts"

		source ${TARGET_CONFIG}/config.sh

		export CROSS_BUILD_SIGN="CROSS_ENV_SET"

		export BUILDMACH=$MACHTYPE

		export NBCORE=-j`nproc`

		export PKG_CONFIG_LIBDIR=${TARGET_ROOTFS}/lib/pkgconfig

		clear

		chmod +x ${BASE_DIR}/targets/${TARGET_NAME}/config/*.sh
		chmod +x ${BASE_DIR}/scripts/*.sh
		chmod +x ${BASE_DIR}/*.sh

		cd   ${BASE_DIR}/targets/${TARGET_NAME}

		SECONDPARAM=${2:-"UNDEF"}
		SECONDPARAM="${SECONDPARAM##*/}"

		if [ $SECONDPARAM = "CLEAN_ALL" ] || [ $SECONDPARAM = "MRPROPER" ]; then

			clean.sh $SECONDPARAM

		else

			echo "************************************************************************"
			echo "* $TARGET_NAME Environment set !"
			echo "*"
			echo "* Commands:"
			echo "* sysbuild.sh                     : Build the whole target system."
			echo "* init_sd.sh [Dev path] [NOSTRIP] : Copy the root-fs to the flash media."
			echo "* clean.sh                        : Delete built objects and root-fs."
			echo "************************************************************************"
			echo

			echo "Current folder :"
			pwd
			echo

			bash

			tset

			echo "************************************************************"
			echo "* You just leaved the "${TARGET_NAME}" build Environment"
			echo "************************************************************"

		fi

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
