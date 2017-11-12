#!/bin/bash

use(){
	echo "${0##*/} <file> [count]"
}

[ $# -lt 1 ] && use $0 && exit 0
FILE_PATH=$1
FILE_SIZE=`ls -al ${FILE_PATH} | awk  '{print $5}'`

SPLITE_CNT=5
[ $# -gt 1 ] && SPLITE_CNT=$2


SPLITE_ALIG=$((1024*1024))

PART_SIZE=$(( (FILE_SIZE / SPLITE_CNT + SPLITE_ALIG - 1) & ~(SPLITE_ALIG - 1) ))

split ${FILE_PATH} -b ${PART_SIZE} -d -a 1 ${FILE_PATH}.part

exit 0

