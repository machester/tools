#!/bin/bash

NAS_FOLDER_Entry=nas
NAS_DIR_NAME_SRC=src
NAS_DIR_NAME_Embedded=Embbedded

NAS_IP="192.168.0.100"
NAS_ACCOUNT_NAME="QUAN"
NAS_ACCOUNT_PW="capsllockJQ2457"

HOME_DIR=`echo $(pwd)`


function mount_nas_list()
{
    # mount command
    # sudo mount -t cifs -o rw,dir_mode=0755,file_mode=0755,sync,username=quan,\
    # password=capsllockJQ2457,vers=3.0,uid=$(id -u),gid=$(id -g),\
    # forceuid,forcegid,mfsymlinks,soft //192.168.3.100/src nas/src

    sudo mount -t cifs -o username=$NAS_ACCOUNT_NAME,password=$NAS_ACCOUNT_PW //$NAS_IP/src $HOME_DIR/$NAS_FOLDER_Entry/$NAS_DIR_NAME_SRC
    sudo mount -t cifs -o username=$NAS_ACCOUNT_NAME,password=$NAS_ACCOUNT_PW //$NAS_IP/Embbedded $HOME_DIR/$NAS_FOLDER_Entry/$NAS_DIR_NAME_SRC
    sudo mount -t cifs -o username=$NAS_ACCOUNT_NAME,password=$NAS_ACCOUNT_PW //$NAS_IP/src $HOME_DIR/$NAS_FOLDER_Entry/$NAS_DIR_NAME_SRC
    sudo mount -t cifs -o username=$NAS_ACCOUNT_NAME,password=$NAS_ACCOUNT_PW //$NAS_IP/Embbedded $HOME_DIR/$NAS_FOLDER_Entry/$NAS_DIR_NAME_SRC
}

function dir_check()
{
    if [ ! -d "$HOME_DIR/$NAS_FOLDER_Entry" ]; then
        echo "--> nas folder has been exist, ready to mount"

    else
        echo "--> reay to ceate nas folder"
        mkdir ${HOME_DIR}/${NAS_FOLDER}
        if [ $? -eq 0 ]
        then
            echo "--> nas folder created"
        else
            echo "--> nas folder creat falied..."
            exit
        fi
    fi
}

echo "--> move to home dir and reay to mount"
sleep 3s
cd ~

# reay to mount nas
echo "--> ready to mount nas"
sleep 1s


if [ $? -eq 0 ]
then
	echo "--> mount nas success"
else
	echo "--> mount nas failed"
fi

# ------------------------ END LINE ---------------------------------
