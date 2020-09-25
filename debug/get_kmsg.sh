#!/bin/bash

log=log.log
reboot_times=0
CUR_PATH=`pwd`
LOG_FLD=$CUR_PATH/Android_LOG/kmsg

function help()
{
	echo "---------------- format ----------------"
	echo " ./reboot_test.sh <reboot times>"
	echo "----------------------------------------"
	exit
}
function log_create() {
    echo "--> current path: $CUR_PATH"
    if [   -d "$LOG_FLD" ]; then
        echo "---> clean log"
        rm -rvf $LOG_FLD/*
    else
        echo "---> create log folder"
        mkdir $LOG_FLD
    fi
}

log_create
index=0

while (true)
do
	adb root
	echo "------------------------ $index ------------------------------" | tee -a $LOG_FILE
	KMSG_LOG_FILE=$LOG_FLD/kmsg_$index.log
	touch $KMSG_LOG_FILE

	adb shell cat /proc/kmsg  | tee -a KMSG_LOG_FILE
	sleep 10s
	let "index++"
done
echo "---------- end reboot test ------------" | tee -a $log
