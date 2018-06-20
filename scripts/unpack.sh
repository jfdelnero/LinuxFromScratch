#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Unpack function
#

function unpack {
	echo "Unpacking $1 ..."
	export TMP_ARCHIVE_FOLDER=`tar tf ${TARGET_DOWNLOAD}/$1 | sed -e 's@/.*@@' | uniq`
	tar xvf ${TARGET_DOWNLOAD}/$1 --directory=${TARGET_SOURCES}/$2  || exit 1
}
