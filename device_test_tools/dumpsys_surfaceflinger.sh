#!/bin/bash

reboot_log=reboot_log.log
loop_times=0
CUR_PATH=`pwd`
LOG_FLD=$CUR_PATH/SURFACE_FLINGER_LOG

RM_LOG=false
function help()
{
	echo "---------------- format ----------------"
	echo " ./reboot_test.sh <loop times>"
	echo "----------------------------------------"
	exit
}

function log_create() {
    echo "--> current path: $CUR_PATH"
    if [   -d "$LOG_FLD" ]; then
        echo "---> clean log"
        read -r  -p "clean log? [y/n]" input
        case $input in
        	[yY][eE][sS]|[yY])
			echo "ready to clean log..."
			RM_LOG=true
			;;
			[nN][oO]|[nN])
			echo "keep log..."
			;;
			*)
			echo "default keep log..."
		esac
		if [ "$RM_LOG" = true ]; then
			rm -rvf $LOG_FLD/*
    	fi
    else
        echo "---> create log folder"
        mkdir $LOG_FLD
    fi
}

# if [ $# -lt 1 ]; then
# 	help
# else
# 	loop_times=$1
# fi
log_create
index=0
x=200
y=125
compare_num=10

DATE=$(date  +%Y%m%d.%H%M%S)
# while (( $index < $loop_times ))
while true
do
	LOOP_LOG_FILE=$LOG_FLD/SurfaceFlinger_$DATE.log
	echo "------------------------ loop $LOOP_LOG_FILE ------------------------------" | tee -a $LOOP_LOG_FILE
	# current_y=`expr $y + $index \* 80`
	# echo "adb shell input tap $x $current_y"  | tee -a $LOOP_LOG_FILE
	# adb shell input tap $x $current_y
	echo "------------------------------------ SurfaceFlinger ------------------------------" | tee -a $LOOP_LOG_FILE
	adb shell dumpsys SurfaceFlinger  | tee -a $LOOP_LOG_FILE
	echo "----------------------------------------------------------------------------------" | tee -a $LOOP_LOG_FILE
	echo "------------------------------------ display summary ------------------------------" | tee -a $LOOP_LOG_FILE
	adb shell cat d/dri/0/summary | tee -a $LOOP_LOG_FILE
	echo "----------------------------------------------------------------------------------" | tee -a $LOOP_LOG_FILE
	let "index++"
	sleep 1s
	if [ $index -eq $compare_num ]
	then
		DATE=$(date  +%Y%m%d.%H%M%S)
		index=0
		current_y=0
		# adb shell input tap 60 230
	fi
done

echo "---------------------------- end -------------------------------"