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

while (true)
do
	echo "------------------------ $index ------------------------------" | tee -a $LOG_FILE
	LOGCAT_LOG_FILE=$LOG_FLD/logcat_$index.log
	KMSG_LOG_FILE=$LOG_FLD/kmsg_$index.log
	TEMP_LOG_FILE=$LOG_FLD/temp_$index.log
	touch $LOGCAT_LOG_FILE
	touch $KMSG_LOG_FILE
	touch $TEMP_LOG_FILE

	
	adb shell logcat | tee -a $LOGCAT_LOG_FILE
	while [ $? -ne 0 ]
	do
		adb shell logcat | tee -a $LOGCAT_LOG_FILE
	done

	adb shell cat /proc/kmsg  | tee -a KMSG_LOG_FILE
	while [ $? -ne 0 ]
	do
		adb shell logcat | tee -a $KMSG_LOG_FILE
	done

	
adb shell  cd /sys/class/thermal/thermal_zone0/
busybox watch -n 2 'cat temp'

adb shell top -m 10
	echo "--------------------------------------------------------------" | tee -a $LOG_FILE
	adb reboot
	sleep 50s
	
	let "index++"
done
echo "---------- end reboot test ------------" | tee -a $log
