#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# Package download script
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

function download_list {
	export TOTALCOUNT=0
	while IFS='' read -r line || [[ -n "$line" ]]; do
	if [[ $line != \#* ]];
	then
		if [ ! -z "$line" ]; then
			export TOTALCOUNT=$((TOTALCOUNT+1))
		fi
	fi
	done < "$1"

	echo $TOTALCOUNT files to check/download...
	export COUNT=1
	export VALIDCOUNT=0
	while IFS='' read -r line || [[ -n "$line" ]]; do
	if [[ $line != \#* ]];
	then
		if [ ! -z "$line" ]; then
			export FILE=$2/${line##*/}

			if [ -f $FILE ]; then
				echo "$COUNT/$TOTALCOUNT : Testing $FILE ..."
				test_archive ${line##*/}
				if [ "$?" -ne "0" ]; then
					rm $FILE
					echo "-----------------------------------------------------------"
					echo "$COUNT/$TOTALCOUNT : Downloading $line ..."
					echo "-----------------------------------------------------------"
					wget -c $line --no-check-certificate --no-clobber --directory-prefix=$2 # --user-agent="Mozilla/5.0 (Linux)"
					echo "$COUNT/$TOTALCOUNT : Testing $FILE ..."
					test_archive ${line##*/}
					if [ "$?" -eq "0" ]; then
						export VALIDCOUNT=$((VALIDCOUNT+1))
					fi
					echo "-----------------------------------------------------------"
				else
					export VALIDCOUNT=$((VALIDCOUNT+1))
				fi
			else
				echo "-----------------------------------------------------------"
				echo "$COUNT/$TOTALCOUNT : Downloading $line ..."
				echo "-----------------------------------------------------------"
				wget -c $line --no-check-certificate --no-clobber --directory-prefix=$2 # --user-agent="Mozilla/5.0 (Linux)"
				echo "$COUNT/$TOTALCOUNT : Testing $FILE ..."
				test_archive ${line##*/}
				if [ "$?" -eq "0" ]; then
					export VALIDCOUNT=$((VALIDCOUNT+1))
				fi
				echo "-----------------------------------------------------------"
			fi

			export COUNT=$((COUNT+1))
		fi
	fi
	done < "$1"

	echo $VALIDCOUNT Valid archives / $TOTALCOUNT

	if [ "$VALIDCOUNT" -eq "$TOTALCOUNT" ]; then
		return 0
	else
		return 1
	fi
}

echo "**********************************"
echo "*   Starting Download packages   *"
echo "**********************************"

mkdir -p ${COMMON_HOME}/download || exit 1
echo >${COMMON_DOWNLOAD}/download_list.txt
set | grep SRC_PACKAGE_BUILD_ | grep "@COMMON@" | sed s#@COMMON@##g | cut -f2 -d"=" >> ${COMMON_DOWNLOAD}/download_list.txt
set | grep SRC_PACKAGE_ | grep -v SRC_PACKAGE_BUILD_ | grep "@COMMON@" | sed s#@COMMON@##g | cut -f2 -d"=" >> ${COMMON_DOWNLOAD}/download_list.txt
download_list ${COMMON_DOWNLOAD}/download_list.txt ${COMMON_DOWNLOAD} || exit 1

mkdir -p ${TARGET_HOME}/download || exit 1
echo >${TARGET_DOWNLOAD}/download_list.txt
set | grep SRC_PACKAGE_ | grep -v SRC_PACKAGE_BUILD_ |grep -v "@COMMON@" | cut -f2 -d"=" >> ${TARGET_DOWNLOAD}/download_list.txt
download_list ${TARGET_DOWNLOAD}/download_list.txt ${TARGET_DOWNLOAD}  || exit 1

exit 0
