#!/bin/bash

NAS_FOLDER=nas
echo "------------> move to home dir and reay to mount"
sleep 3s
cd ~
HOME_DIR=`echo $(pwd)`

if [ ! -d "/${NAS_FOLDER}" ]
then
    echo "------------> nas folder has been exist, ready to mount"

else
	echo "------------> reay to ceate nas folder"
	mkdir ${HOME_DIR}/${NAS_FOLDER}
    if [ $? -eq 0 ]
    then
        echo "------------> nas folder created"
    else
        echo "------------> nas folder creat falied..."
        exit
    fi
fi
# reay to mount nas
echo "------------> ready to mount nas"
sleep 1s
sudo mount -t cifs -o username=quan,password=capsllockjq2457 //192.168.3.5/Linux_Fireware ~/nas
if [ $? -eq 0 ]
then
	echo "------------> mount nas success"
else
	echo "------------> mount nas failed"
fi

# ------------------------ END LINE ---------------------------------
