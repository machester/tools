#!/bin/bash
echo "----------- start caputre --------------"
index=0
rm -f storage/emulated/0/Pictures/*
while [ $index -lt 1000 ]
do
	DATE=$(date  +%Y%m%d-%H%M%S)
	adb shell screencap -p storage/emulated/0/Pictures/cap_$index_$DATE.png
	let index++;
	echo "---> index = $index"
	sleep 1s
	
done
echo "---------------- end --------------------"
