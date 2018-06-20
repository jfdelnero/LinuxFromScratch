#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Miscellaneous stuffs
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1

source ${TARGET_CONFIG}/config.sh || exit 1

echo "*********************"
echo "*   Miscellaneous   *"
echo "*********************"

####################################################################
# SDPARM
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SDPARM:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir sdparm
		cd sdparm || exit 1

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

####################################################################
# HDIDLE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_HDIDLE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

		export CROSS=${TGT_MACH}
		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar
		export TARGET_DIR=${TARGET_ROOTFS}

		sed -i s#-g\ root\ -o\ root##g Makefile || exit 1

		make ${NBCORE}          || exit 1
		make ${NBCORE} install  || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# PCI UTILS
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_PCIUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

		make ${NBCORE} CROSS_COMPILE=${TGT_MACH}- PREFIX=${TARGET_ROOTFS} HOST=${TARGET_ROOTFS} || exit 1
		make ${NBCORE} CROSS_COMPILE=${TGT_MACH}- PREFIX=${TARGET_ROOTFS} HOST=${TARGET_ROOTFS} STRIP="-s --strip-program=${TGT_MACH}-strip"  install  || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# PYTHON
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_PYTHON:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1

		mkdir python
		cd python || exit 1

		echo ac_cv_file__dev_ptmx=no > ./config.site
		echo ac_cv_file__dev_ptc=no >> ./config.site
		export CONFIG_SITE=config.site

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix= \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--disable-ipv6 \
				--enable-shared \
				|| exit 1

		make ${NBCORE} || exit 1
		make ${NBCORE} altinstall DESTDIR=${TARGET_ROOTFS} || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBAIO
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBAIO:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		make ${NBCORE} prefix=${TARGET_ROOTFS} || exit 1
		make ${NBCORE} prefix=${TARGET_ROOTFS} install  || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBUSB
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBUSB:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir libusb
		cd libusb || exit 1

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

####################################################################
# LIBUSB Gadget
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBUSBGADGET:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir libusbgadget
		cd libusbgadget || exit 1

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

####################################################################
# Nano
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_NANOEDITOR:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir nano
		cd nano || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${NBCORE} CFLAGS="-I/${TARGET_ROOTFS}/include/ncurses" CPPFLAGS="-I${TARGET_ROOTFS}/include/ncurses" || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

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
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

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

		make steamlink REGENIE=1 SOURCES=src/mame/drivers/pacman.cpp -j3  NO_USE_MIDI=1 NO_X11=1 || exit 1

		mkdir ${TARGET_ROOTFS}/mame
		cp mame ${TARGET_ROOTFS}/mame || exit 1

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
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		make ${NBCORE} -f Makefile COPYDIR="$BASEQ3_DIR" ARCH=arm \
			CC="${TGT_MACH}-gcc" USE_SVN=0 USE_CURL=0 USE_OPENAL=0 \
			CFLAGS="-DVCMODS_MISC -DVCMODS_OPENGLES -DVCMODS_DEPTH -DVCMODS_REPLACETRIG $INCLUDES -lSDL -lvchostif -lvcfiled_check -lbcm_host -lkhrn_static -lvchiq_arm -lopenmaxil -lEGL -lGLESv2 -lvcos -lrt" || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi
