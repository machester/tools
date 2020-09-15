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
TEMP_LOG_FILE=$LOG_FLD/temp_log.log
while (true)
do
	echo "------------------------ $index ------------------------------" | tee -a $TEMP_LOG_FILE
	# TEMP_LOG_FILE=$LOG_FLD/temp_$index.log

	touch $TEMP_LOG_FILE
	echo "--------------------------------------------------------------------" | tee -a $TEMP_LOG_FILE
	echo "TEMP:" | tee -a $TEMP_LOG_FILE
	adb shell  cat sys/class/thermal/thermal_zone0/temp | tee -a $TEMP_LOG_FILE
	echo "CPU Freq:" | tee -a $TEMP_LOG_FILE
	adb shell  cat sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq | tee -a $TEMP_LOG_FILE
	echo "GPU Freq:" | tee -a $TEMP_LOG_FILE
	adb shell cat  sys/devices/platform/ffa30000.gpu/devfreq/ffa30000.gpu/cur_freq |  tee -a $TEMP_LOG_FILE
	echo "Free memory:" | tee -a $TEMP_LOG_FILE
	adb shell free memory -h | tee -a $TEMP_LOG_FILE
	echo "--------------------------------------------------------------------" | tee -a $TEMP_LOG_FILE
	sleep 2s
	let "index++"
done
echo "---------- end reboot test ------------" | tee -a $log
