#!/bin/bash
echo "----------- start caputre --------------"
index=0
rm -f storage/emulated/0/Pictures/*
while [ $index -lt 20000 ]
do
	DATE=$(date  +%Y%m%d_%H%M%S)
	# adb shell screencap -p storage/emulated/0/Pictures/cap_$index_$DATE.png
	echo "---> index = $index"
	echo "caputre file name pic_$index-$DATE.png"
	adb shell screencap -p storage/emulated/0/Screenshots/pic_$index-$DATE.png
	let index++;
	sleep 1s
	
done
echo "---------------- end --------------------"
