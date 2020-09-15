#!/bin/bash

log=log.log
reboot_times=0
CUR_PATH=`pwd`
LOG_FLD=$CUR_PATH/Android_LOG

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
TOP_LOG_FILE=$LOG_FLD/top_log.log
while (true)
do
	echo "------------------------ $index ------------------------------" | tee -a $TOP_LOG_FILE
	# TOP_LOG_FILE=$LOG_FLD/temp_$index.log

	echo "TOP:" | tee -a $TOP_LOG_FILE
	adb shell top -m 20 | tee -a $TOP_LOG_FILE
	echo "--------------------------------------------------------------------" | tee -a $TOP_LOG_FILE
	sleep 2s
	let "index++"
done
echo "---------- end reboot test ------------" | tee -a $log
