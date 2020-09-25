#!/bin/bash

log=log.log
reboot_times=0
CUR_PATH=`pwd`
LOG_FLD=$CUR_PATH/Android_LOG/logcat

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
	echo "------------------------ $index ------------------------------" | tee -a $LOG_FILE

	LOGCAT_LOG_FILE=$LOG_FLD/logcat_$index.log
	touch $LOGCAT_LOG_FILE
	adb shell logcat | tee -a $LOGCAT_LOG_FILE

	sleep 10s
	# while [ $? -ne 0 ]
	# do
		# LOGCAT_LOG_FILE=$LOG_FLD/logcat_$index.log
		# touch $LOGCAT_LOG_FILE
		# adb shell logcat | tee -a $LOGCAT_LOG_FILE
		let "index++"
	# done
done
echo "---------- end reboot test ------------" | tee -a $log
