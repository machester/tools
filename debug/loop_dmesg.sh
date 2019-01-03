#!/bin/bash

while true
do
		dmesg -T --level=err | tail -5
		echo "----------------------------------------------------"
		sleep 3s
done
