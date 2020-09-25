#!/bin/bash

reboot_log=reboot_log.log
reboot_times=0

# function help()
# {
# 	echo "---------------- format ----------------"
# 	echo " ./reboot_test.sh <reboot times>"
# 	echo "----------------------------------------"
# 	exit
# }


# if [ $# -lt 1 ]; then
# 	help
# else
# 	reboot_times=$1
# fi

rm -vf $reboot_log
touch $reboot_log
index=0
echo "---------- start reboot test ------------" | tee -a $reboot_log
while (true)
do
	echo "--------------- $index ----------------------" | tee -a $reboot_log
	adb devices | tee -a adb_devices_$index.log
	grep -nrs RKdrm adb_devices_$index.log
	if [ 0 -eq $? ]; then
		adb shell dmesg | tee -a $reboot_log
	fi
	rm -vf adb_devices_$index.log
	echo "-----------------------------------------" | tee -a $reboot_log
	sleep 3s
	let "index++"
done
echo "---------- end reboot test ------------" | tee -a $reboot_log
