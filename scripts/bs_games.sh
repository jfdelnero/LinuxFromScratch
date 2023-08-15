#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Games
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

echo "*************"
echo "*   Games   *"
echo "*************"

####################################################################
# Mame
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_MAME:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		########################################################################################################################
		# Mame hack/patch :
		sed -i s#\$\(MARVELL_SDK_PATH\)/toolchain/bin/armv7a-cros-linux-gnueabi-#${TGT_MACH}-#g ./scripts/toolchain.lua || exit 1
		sed -i s#\$\(MARVELL_SDK_PATH\)/toolchain/bin/armv7a-cros-linux-gnueabi-#${TGT_MACH}-#g ./3rdparty/bx/scripts/toolchain.lua || exit 1

		#sed -i s#\"__STEAMLINK__\=1\"#--\"__STEAMLINK__\=1\"#g ./scripts/toolchain.lua || exit 1
		#sed -i s#\"__STEAMLINK__\=1\"#--\"__STEAMLINK__\=1\"#g ./3rdparty/bx/scripts/toolchain.lua || exit 1

		sed -i s#\"__STEAMLINK__\=1\"#\"PTR64\=1\",\"MESA_EGL_NO_X11_HEADERS\=1\"#g ./scripts/toolchain.lua || exit 1
		sed -i s#\"__STEAMLINK__\=1\"#\"PTR64\=1\",\"MESA_EGL_NO_X11_HEADERS\=1\"#g ./3rdparty/bx/scripts/toolchain.lua || exit 1

		sed -i s#-mfloat-abi\=hard##g ./scripts/toolchain.lua || exit 1
		sed -i s#-mfloat-abi\=hard##g ./3rdparty/bx/scripts/toolchain.lua || exit 1

		sed -i s#-marm##g ./scripts/toolchain.lua || exit 1
		sed -i s#-marm##g ./3rdparty/bx/scripts/toolchain.lua || exit 1

		sed -i s#-static-libstdc++##g ./scripts/toolchain.lua || exit 1
		sed -i s#-static-libstdc++##g ./3rdparty/bx/scripts/toolchain.lua || exit 1

		sed -i s#-static-libstdc##g ./scripts/toolchain.lua || exit 1
		sed -i s#-static-libstdc##g ./3rdparty/bx/scripts/toolchain.lua || exit 1

		sed -i s#-static-libgcc##g ./scripts/toolchain.lua || exit 1
		sed -i s#-static-libgcc##g ./3rdparty/bx/scripts/toolchain.lua || exit 1

		sed -i s#--sysroot=\$\(MARVELL_SDK_PATH\)/rootfs##g ./scripts/toolchain.lua || exit 1
		sed -i s#--sysroot=\$\(MARVELL_SDK_PATH\)/rootfs##g ./3rdparty/bx/scripts/toolchain.lua || exit 1

		sed -i s#BX_PLATFORM_LINUX#BX_PLATFORM__STEAMLINK#g ./3rdparty/bgfx/src/config.h || exit 1
		sed -i s#BX_PLATFORM_STEAMLINK#BX_PLATFORM_LINUX#g ./3rdparty/bgfx/src/config.h || exit 1
		sed -i s#BX_PLATFORM__STEAMLINK#BX_PLATFORM_STEAMLINK#g ./3rdparty/bgfx/src/config.h || exit 1

		sed -i s#\"X11\"#--\"X11\"#g ./3rdparty/bgfx/scripts/genie.lua || exit 1
#		sed -i s#\"EGL\"#--\"EGL\"#g ./3rdparty/bgfx/scripts/genie.lua || exit 1
#		sed -i s#\"EGL\"#--\"EGL\"#g ./scripts/genie.lua || exit 1
		sed -i s#\"EGL\"#\"asound\"#g ./3rdparty/bgfx/scripts/genie.lua || exit 1
		sed -i s#\"EGL\"#\"asound\"#g ./scripts/genie.lua || exit 1

		sed -i s#\"EGL_API_FB\"#--\"EGL_API_FB\"#g ./scripts/genie.lua || exit 1

		sed -i s#\"EGL_API_FB\"#--\"EGL_API_FB\"#g ./src/osd/modules/render/drawbgfx.cpp

		sed -i s#BX_PLATFORM_LINUX#BX_PLATFORM_STEAMLINK#g     ./src/osd/modules/render/drawbgfx.cpp || exit 1
		sed -i s#BX_PLATFORM_EMSCRIPTEN#BX_PLATFORM_LINUX#g      ./src/osd/modules/render/drawbgfx.cpp || exit 1
		#sed -i s#BX_PLATFORM__STEAMLINK#BX_PLATFORM_STEAMLINK#g ./src/osd/modules/render/drawbgfx.cpp || exit 1

		export MARVELL_SDK_PATH="${TARGET_CROSS_TOOLS}"
		export MARVELL_ROOTFS="${TARGET_ROOTFS}"

		########################################################################################################################

		make ${MAKE_FLAGS} steamlink REGENIE=1 SOURCES=src/mame/drivers/pacman.cpp -j3  NO_USE_MIDI=1 NO_X11=1 || exit 1

		mkdir ${TARGET_ROOTFS}/mame
		cp mame ${TARGET_ROOTFS}/mame || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Doom
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_DOOM:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir doom
		cd doom || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Quake 3
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_QUAKE3:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		make ${MAKE_FLAGS} ${NBCORE} -f Makefile COPYDIR="$BASEQ3_DIR" ARCH=arm \
			CC="${TGT_MACH}-gcc" USE_SVN=0 USE_CURL=0 USE_OPENAL=0 \
			CFLAGS="-DVCMODS_MISC -DVCMODS_OPENGLES -DVCMODS_DEPTH -DVCMODS_REPLACETRIG $INCLUDES -lSDL -lvchostif -lvcfiled_check -lbcm_host -lkhrn_static -lvchiq_arm -lopenmaxil -lEGL -lGLESv2 -lvcos -lrt" || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi
