#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Graphic stack
#

source ${BASE_DIR}/scripts/unpack.sh || exit 1

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

echo "*****************"
echo "* Graphic stack *"
echo "*****************"

####################################################################
# LibPNG
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBPNG:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(

		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir libpng
		cd libpng || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				|| exit 1

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LibDRM
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBDRM:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(

		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir libdrm
		cd libdrm || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				--enable-vc4 \
				--enable-install-test-programs \
				|| exit 1

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Mesa
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_MESA:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		export PKG_CONFIG_PATH=${TARGET_ROOTFS}/lib/pkgconfig

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		if [ -f ${BASE_DIR}/configs/${TARGET_NAME}/patchs/mesa_configure_ac.patch ]
		then
		(
			patch -Zf < ${BASE_DIR}/configs/${TARGET_NAME}/patchs/mesa_configure_ac.patch  || exit 1
		) || exit 1
		fi

		# export WAYLAND_SCANNER_PATH=${BASE_DIR}/build/${TARGET_NAME}/wayland_scanner_build/wayland-scanner

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir mesa
		cd mesa || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH \
					--enable-opengl \
					--enable-shared-glapi \
					--enable-gles1 \
					--enable-gles2 \
					--enable-egl \
					--enable-gbm \
					--enable-gallium-osmesa \
					--disable-glx \
					--enable-dri \
					--disable-dri3 \
					--with-platforms=drm,surfaceless \
					--with-dri-drivers=swrast \
					--with-gallium-drivers=vc4,swrast \
					CFLAGS="-DHAVE_PIPE_LOADER_DRI -DHAVE_PIPE_LOADER_KMS" || exit 1

		#--with-platforms=wayland,drm,surfaceless \

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Mesa Lima
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_MESALIMA:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		#unpack ${CUR_PACKAGE} ""
		export TMP_ARCHIVE_FOLDER="mesa-lima-lima-17.3"

		unzip  ${BASE_DIR}/download/${TARGET_NAME}/${CUR_PACKAGE} -d ${BASE_DIR}/sources/${TARGET_NAME}/

		export PKG_CONFIG_PATH=${TARGET_ROOTFS}/lib/pkgconfig

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		./autogen.sh

		#if [ -f ${BASE_DIR}/configs/${TARGET_NAME}/patchs/mesa_configure_ac.patch ]
		#then
		#(
		#	patch -Zf < ${BASE_DIR}/configs/${TARGET_NAME}/patchs/mesa_configure_ac.patch  || exit 1
		#) || exit 1
		#fi

		# export WAYLAND_SCANNER_PATH=${BASE_DIR}/build/${TARGET_NAME}/wayland_scanner_build/wayland-scanner

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir mesa
		cd mesa || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH \
					--enable-opengl \
					--enable-shared-glapi \
					--enable-gles1 \
					--enable-gles2 \
					--enable-egl \
					--enable-gbm \
					--disable-glx \
					--enable-dri \
					--disable-dri3 \
					--enable-gallium-osmesa \
					--with-platforms=drm,surfaceless \
					--with-dri-drivers=swrast \
					--with-gallium-drivers=lima,swrast \
					--with-egl-platforms=drm \
					--enable-debug \
					--disable-xvmc \
					--disable-vdpau \
					|| exit 1

#					--enable-gallium-osmesa \
#					--with-dri-drivers=swrast \
#					--with-gallium-drivers=lima,swrast \

		#--with-platforms=wayland,drm,surfaceless \

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LibEpoxy
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBEPOXY:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(

		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		export PKG_CONFIG_PATH=${TARGET_ROOTFS}/lib/pkgconfig

		./autogen.sh

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir libepoxy
		cd libepoxy || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				--disable-glx \
				|| exit 1

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Lib Glew
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_GLEW:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		export PKG_CONFIG_PATH=${TARGET_ROOTFS}/lib/pkgconfig
		export GLEW_PREFIX=${TARGET_ROOTFS}/
		export GLEW_DEST=${TARGET_ROOTFS}/

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		cat "./config/Makefile.linux" | sed s#\-Wl\,##g > "./config/Makefile.linux_" || exit 1
		cp ./config/Makefile.linux_ ./config/Makefile.linux  || exit 1

		make ${NBCORE} STRIP=${TGT_MACH}-strip CC=${TGT_MACH}-gcc LD=${TGT_MACH}-ld AR=${TGT_MACH}-ar AS=${TGT_MACH}-as  SYSTEM=linux-osmesa         || exit 1
		make ${NBCORE} install STRIP=${TGT_MACH}-strip CC=${TGT_MACH}-gcc LD=${TGT_MACH}-ld AR=${TGT_MACH}-ar AS=${TGT_MACH}-as  SYSTEM=linux-osmesa || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Lib Glu
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_GLU:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir glu
		cd glu || exit 1

		export PKG_CONFIG_PATH=${TARGET_ROOTFS}/lib/pkgconfig

		sed -i.bak 's/armv\[345\]\[lb\]/armv\[34567\]\[lba\]/g' ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/config.sub

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
			--prefix="${TARGET_ROOTFS}" \
			--host=${TGT_MACH} \
			--enable-osmesa || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Lib Glut
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_GLUT:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		make ${NBCORE} configure STRIP=${TGT_MACH}-strip CC=${TGT_MACH}-gcc LD=${TGT_MACH}-ld AR=${TGT_MACH}-ar AS=${TGT_MACH}-as  linux-osmesa || exit 1
		make ${NBCORE} STRIP=${TGT_MACH}-strip CC=${TGT_MACH}-gcc LD=${TGT_MACH}-ld AR=${TGT_MACH}-ar AS=${TGT_MACH}-as  linux-osmesa           || exit 1
		make ${NBCORE} install STRIP=${TGT_MACH}-strip CC=${TGT_MACH}-gcc LD=${TGT_MACH}-ld AR=${TGT_MACH}-ar AS=${TGT_MACH}-as  linux-osmesa   || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Freetype
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_FREETYPE:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir freetype
		cd freetype || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--without-png || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# FontConfig
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_FONTCONFIG:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		export PKG_CONFIG_PATH=${TARGET_ROOTFS}/lib/pkgconfig

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		#disable tests...
		echo all: >./test/Makefile      || exit 1
		echo install: >>./test/Makefile || exit 1

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir fontconfig
		cd fontconfig || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
			--prefix="${TARGET_ROOTFS}" \
			--host=$TGT_MACH \
			--without-python \
			--enable-libxml2 || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# DirectFB
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_DIRECTFB:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		cat "./systems/egl/egl_system.c" | sed s#define\ RASPBERRY_PI#undef\ RASPBERRY_PI#g > "./systems/egl/egl_system.patched" || exit 1
		cp ./systems/egl/egl_system.patched ./systems/egl/egl_system.c

		cd ./systems/mesa || exit 1
		patch -Z < ${BASE_DIR}/configs/${TARGET_NAME}/patchs/mesa_surface_pool.patch  || exit 1

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir directfb
		cd directfb || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH \
					CC=${TGT_MACH}-gcc \
					--disable-x11 \
					--disable-x11vdpau \
					--enable-mesa \
					--enable-fbdev \
					--enable-idirectfbgl-egl \
					--disable-egl \
					--enable-egl-united  \
					--disable-vnc \
					--disable-osx \
					--disable-png \
					--disable-gif \
					--enable-zlib \
					--disable-multi \
					--with-inputdrivers=linuxinput \
					--with-gfxdrivers=gles2 \
					--without-vorbis \
					--without-timidity \
					--without-tremor \
					--without-cdda \
					--without-wave \
					--without-playlist \
					CFLAGS="-DMESA_EGL_NO_X11_HEADERS" \
					 || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# SDL
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SDL:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir sdl2
		cd sdl2 || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--without-x \
				--disable-video-x11 \
				--disable-x11-shared \
				--disable-video-x11-xcursor \
 				--disable-video-x11-xinerama \
 				--disable-video-x11-xinput \
 				--disable-video-x11-xrandr \
 				--disable-video-x11-scrnsaver \
 				--disable-video-x11-xshape \
 				--disable-video-x11-vm \
 				--disable-esd \
 				--disable-video-mir \
 				--enable-video-wayland \
 				--disable-video-opengl \
 				--enable-video-rpi \
 				--enable-video-opengl \
 				--enable-video-opengles \
 				--enable-video-opengles1 \
 				--enable-video-opengles2 \
 				--enable-video-dummy \
 				--enable-video-directfb \
 				--disable-haptic \
 				--disable-directfb-shared \
 				--disable-pulseaudio \
 				CFLAGS="-DPATH_MAX=4096 -DSDL_DIRECTFB_OPENGL" || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# SDL TTF
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SDL_TTF:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER} || exit 1

		cat "configure" | sed s#SDL_opengl#SDL_opengll#g > "configure_n" || exit 1
		cp "configure_n" "configure"

		cd ${BASE_DIR}/build/${TARGET_NAME} || exit 1
		mkdir sdl2ttf
		cd sdl2ttf || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--host=$TGT_MACH \
				--prefix="${TARGET_ROOTFS}" \
				--disable-sdltest \
				--with-sdl-prefix="${TARGET_ROOTFS}" \
				--with-freetype-prefix="${TARGET_ROOTFS}" \
				CFLAGS=-DPATH_MAX=4096 || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

