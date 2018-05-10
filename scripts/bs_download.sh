#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Package download script
#

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

function dowload_list {
	while IFS='' read -r line || [[ -n "$line" ]]; do
	if [[ $line != \#* ]];
	then
		echo "Downloading $line ..."
		wget -c $line --no-check-certificate --no-clobber --directory-prefix=${BASE_DIR}/download/$TARGET_NAME
	fi
	done < "$1"
}

echo "**********************************"
echo "*   Starting Download packages   *"
echo "**********************************"

mkdir -p ${BASE_DIR}/download || exit 1
mkdir -p ${BASE_DIR}/download/$TARGET_NAME || exit 1

set | grep SRC_PACKAGE_ | cut -f2 -d"=" > ${BASE_DIR}/build/$TARGET_NAME/download_list.txt

dowload_list ${BASE_DIR}/build/$TARGET_NAME/download_list.txt

exit 0
