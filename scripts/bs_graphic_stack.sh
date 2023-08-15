#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Graphic stack
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

echo "*****************"
echo "* Graphic stack *"
echo "*****************"

####################################################################
# LibPNG
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBPNG:-"UNDEF"}
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
		mkdir libpng
		cd libpng || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Lib PCIACCESS
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBPCIACCESS:-"UNDEF"}
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
		mkdir libpciaccess
		cd libpciaccess || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LibDRM
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBDRM:-"UNDEF"}
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

		sed -i s#-DDEBUG#-D__DEBUG__#g nouveau/Makefile.in || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libdrm
		cd libdrm || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				${DRM_SUPPORT} \
				--enable-install-test-programs \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Wayland
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_WAYLAND:-"UNDEF"}
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

		unset PKG_CONFIG_LIBDIR
		export PKG_CONFIG_PATH=${TARGET_CROSS_TOOLS}/lib/pkgconfig

		sed -i s#\@USE_HOST_SCANNER_TRUE\@wayland_scanner\ =\ wayland-scanner#\@USE_HOST_SCANNER_TRUE\@wayland_scanner\ =\ \'\$\(top_builddir\)/..\\/wayland_scanner/wayland-scanner\'#g Makefile.in || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1

		# wayland_scanner build
		mkdir wayland_scanner
		cd wayland_scanner || exit 1
		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure --disable-static -disable-documentation || exit 1
		make ${MAKE_FLAGS} || exit 1

		export PKG_CONFIG_PATH=
		export WAYLAND_SCANNER_PATH=${TMP_BUILD_FOLDER}/wayland_scanner/wayland-scanner

		cd ..

		export PKG_CONFIG_LIBDIR=${TARGET_ROOTFS}/lib/pkgconfig

		mkdir wayland_target
		cd wayland_target || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure --prefix="${TARGET_ROOTFS}" --with-host-scanner=yes --disable-static -disable-documentation --host=$TGT_MACH || exit 1

		make ${MAKE_FLAGS} || exit 1
		make ${MAKE_FLAGS} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Wayland Protocols
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_WAYLANDPROTOCOLS:-"UNDEF"}
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

		mkdir wayland_protocols
		cd wayland_protocols || exit 1

		export WAYLAND_SCANNER_PATH=${TMP_BUILD_FOLDER}/wayland_scanner/wayland-scanner

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure --prefix="${TARGET_ROOTFS}" --host=$TGT_MACH || exit 1

		make ${MAKE_FLAGS} || exit 1
		make ${MAKE_FLAGS} install || exit 1

		mv  ${TARGET_ROOTFS}/share/pkgconfig/wayland-protocols.pc ${TARGET_ROOTFS}/lib/pkgconfig/wayland-protocols.pc  || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Mesa
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_MESA:-"UNDEF"}
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

		# Fix x86-x86 cross compilation : temporary "hide" the target wayland scanner.
		[[ -z "${SRC_PACKAGE_WAYLAND+x}" ]] && echo || mv ${TARGET_ROOTFS}/bin/wayland-scanner ${TARGET_ROOTFS}/bin/wayland-scanner_target
		[[ -z "${SRC_PACKAGE_WAYLAND+x}" ]] && echo || ln -s ${TMP_BUILD_FOLDER}/wayland_scanner/wayland-scanner ${TARGET_ROOTFS}/bin/wayland-scanner

		export WAYLAND_SCANNER_PATH=${TMP_BUILD_FOLDER}/wayland_scanner/wayland-scanner

		[[ -z "${SRC_PACKAGE_WAYLAND+x}" ]] && PLATEFORM_LIST="drm,surfaceless" || PLATEFORM_LIST="wayland,drm,surfaceless"

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		if [ -f ${TARGET_CONFIG}/patches/mesa_configure_ac.patch ]
		then
		(
			patch -Zf < ${TARGET_CONFIG}/patches/mesa_configure_ac.patch  || exit 1
		) || exit 1
		fi

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir mesa
		cd mesa || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
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
					--disable-dri3 \
					--enable-dri \
					--with-platforms=${PLATEFORM_LIST} \
					--with-dri-drivers=${MESA_DRI_DRV} \
					--with-gallium-drivers=${MESA_GALLIUM_DRV} \
					WAYLAND_SCANNER_PATH=${TMP_BUILD_FOLDER}/wayland_scanner/wayland-scanner \
					CFLAGS="-DHAVE_PIPE_LOADER_DRI -DHAVE_PIPE_LOADER_KMS" || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		# Restore target wayland-scanner
		[[ -z "${SRC_PACKAGE_WAYLAND+x}" ]] && echo || rm ${TARGET_ROOTFS}/bin/wayland-scanner
		[[ -z "${SRC_PACKAGE_WAYLAND+x}" ]] && echo || mv ${TARGET_ROOTFS}/bin/wayland-scanner_target ${TARGET_ROOTFS}/bin/wayland-scanner

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# xkbcommon
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBXKBCOMMON:-"UNDEF"}
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

		mkdir xkbcommon
		cd xkbcommon || exit 1

		export wayland_scanner=${TMP_BUILD_FOLDER}/wayland_scanner/wayland-scanner

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure --prefix="${TARGET_ROOTFS}" --host=$TGT_MACH --disable-x11 || exit 1

		sed -i s#wayland_scanner\ \=#wayland_scanner\ \=${wayland_scanner}\ \\##g Makefile || exit 1

		make ${MAKE_FLAGS} || exit 1
		make ${MAKE_FLAGS} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# pixman
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_PIXMAN:-"UNDEF"}
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

		mkdir pixman
		cd pixman || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure --prefix="${TARGET_ROOTFS}" --host=$TGT_MACH || exit 1

		make ${MAKE_FLAGS} || exit 1
		make ${MAKE_FLAGS} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LibEpoxy
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBEPOXY:-"UNDEF"}
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

		./autogen.sh

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libepoxy
		cd libepoxy || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				--disable-glx \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Lib Glew
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_GLEW:-"UNDEF"}
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

		export GLEW_PREFIX=${TARGET_ROOTFS}/
		export GLEW_DEST=${TARGET_ROOTFS}/

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		sed -i s#\-Wl\,##g ./config/Makefile.linux || exit 1

		make ${MAKE_FLAGS} ${NBCORE} STRIP=${TGT_MACH}-strip CC=${TGT_MACH}-gcc LD=${TGT_MACH}-ld AR=${TGT_MACH}-ar AS=${TGT_MACH}-as  SYSTEM=linux-osmesa         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install STRIP=${TGT_MACH}-strip CC=${TGT_MACH}-gcc LD=${TGT_MACH}-ld AR=${TGT_MACH}-ar AS=${TGT_MACH}-as  SYSTEM=linux-osmesa || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Lib Glu
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_GLU:-"UNDEF"}
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
		mkdir glu
		cd glu || exit 1

		sed -i.bak 's/armv\[345\]\[lb\]/armv\[34567\]\[lba\]/g' ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/config.sub

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
			--prefix="${TARGET_ROOTFS}" \
			--host=${TGT_MACH} \
			--enable-osmesa || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Lib Glut
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_GLUT:-"UNDEF"}
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

		make ${MAKE_FLAGS} ${NBCORE} configure STRIP=${TGT_MACH}-strip CC=${TGT_MACH}-gcc LD=${TGT_MACH}-ld AR=${TGT_MACH}-ar AS=${TGT_MACH}-as  linux-osmesa || exit 1
		make ${MAKE_FLAGS} ${NBCORE} STRIP=${TGT_MACH}-strip CC=${TGT_MACH}-gcc LD=${TGT_MACH}-ld AR=${TGT_MACH}-ar AS=${TGT_MACH}-as  linux-osmesa           || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install STRIP=${TGT_MACH}-strip CC=${TGT_MACH}-gcc LD=${TGT_MACH}-ld AR=${TGT_MACH}-ar AS=${TGT_MACH}-as  linux-osmesa   || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Freetype
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_FREETYPE:-"UNDEF"}
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
		mkdir freetype
		cd freetype || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--with-harfbuzz=no \
				--without-png || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# FontConfig
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_FONTCONFIG:-"UNDEF"}
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

		#disable tests...
		echo all: >./test/Makefile      || exit 1
		echo install: >>./test/Makefile || exit 1

		# x86-x86 cross compilation : Force the cross compile mode !
		sed -i s#cross_compiling\=no#cross_compiling\=yes#g configure || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir fontconfig
		cd fontconfig || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
			--prefix="${TARGET_ROOTFS}" \
			--host=$TGT_MACH \
			--without-python \
			--disable-docs \
			--enable-libxml2 || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# DirectFB
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_DIRECTFB:-"UNDEF"}
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

		sed -i s#define\ RASPBERRY_PI#undef\ RASPBERRY_PI#g ./systems/egl/egl_system.c || exit 1

		cd ./systems/mesa || exit 1
		patch -Z < ${TARGET_CONFIG}/patches/mesa_surface_pool.patch  || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir directfb
		cd directfb || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH \
					CC=${TGT_MACH}-gcc \
					--disable-x11 \
					--disable-x11vdpau \
					--enable-mesa \
					--enable-fbdev \
					--enable-idirectfbgl-egl \
					--enable-egl \
					--enable-drmkms \
					--enable-sdl \
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

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# SDL
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SDL:-"UNDEF"}
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
		mkdir sdl2
		cd sdl2 || exit 1

		# Point to the host wayland scanner !
		sed -i s#WAYLAND_SCANNER\=#WAYLAND_SCANNER\=${TMP_BUILD_FOLDER}/wayland_scanner/wayland-scanner\ \\##g ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
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
 				--enable-video-rpi \
 				--enable-video-opengl \
 				--enable-video-opengles \
 				--enable-video-opengles1 \
 				--enable-video-opengles2 \
 				--enable-video-dummy \
 				--enable-video-directfb \
 				--enable-video-kmsdrm \
 				--disable-haptic \
 				--disable-directfb-shared \
 				--disable-pulseaudio \
 				CFLAGS="-DPATH_MAX=4096 -DMESA_EGL_NO_X11_HEADERS" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

	#	SDL Test programs
		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir sdl2_tests
		cd sdl2_tests || exit 1

		# disable testshader...
		sed -i s#testshader\$\(EXE\)\ #\ #g ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/test/Makefile.in || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/test/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--disable-testshader \
				CFLAGS="-DPATH_MAX=4096" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1

		mkdir ${TARGET_ROOTFS}/sdltests
		cp *  ${TARGET_ROOTFS}/sdltests

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# SDL TTF
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SDL_TTF:-"UNDEF"}
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

		sed -i s#SDL_opengl#SDL_opengll#g configure || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir sdl2ttf
		cd sdl2ttf || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--host=$TGT_MACH \
				--prefix="${TARGET_ROOTFS}" \
				--disable-sdltest \
				--with-sdl-prefix="${TARGET_ROOTFS}" \
				--with-freetype-prefix="${TARGET_ROOTFS}" \
				CFLAGS="-DPATH_MAX=4096" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# SDL NET
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SDL_NET:-"UNDEF"}
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
		mkdir sdlnet
		cd sdlnet || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# CAIRO
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_CAIRO:-"UNDEF"}
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
		mkdir cairo
		cd cairo || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--with-x=no \
				--enable-xlib=no \
				--enable-xlib-xrender=no \
				--enable-glesv2=yes \
				--enable-directfb=no \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Weston (Wayland)
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_WAYLANDWESTON:-"UNDEF"}
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

		mkdir wayland_weston
		cd wayland_weston || exit 1

		export WAYLAND_SCANNER_PATH=${TMP_BUILD_FOLDER}/wayland_scanner/wayland-scanner
		export wayland_scanner=${TMP_BUILD_FOLDER}/wayland_scanner/wayland-scanner

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure --prefix=${TARGET_ROOTFS} --host=$TGT_MACH \
				--disable-x11-compositor \
				--disable-xwayland \
				--disable-setuid-install \
				--disable-systemd-login \
				--enable-weston-launch \
				--disable-devdocs \
				--enable-simple-clients \
				--enable-simple-dmabuf-drm-client \
				--enable-simple-egl-clients \
				--enable-demo-clients-install \
				WESTON_NATIVE_BACKEND="drm-backend.so" \
				--includedir=${TARGET_ROOTFS}/include \
				--sysconfdir=/etc \
				--localstatedir=/var \
				lt_sysroot=${TARGET_ROOTFS}/lib \
				--libdir=${TARGET_ROOTFS}/lib \
				--disable-silent-rules || exit 1

		make ${MAKE_FLAGS} || exit 1
		make ${MAKE_FLAGS} install || exit 1
		#make ${MAKE_FLAGS} install DESTDIR=${TARGET_ROOTFS} || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LibGD
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBGD:-"UNDEF"}
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
		mkdir libgd
		cd libgd || exit 1

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
