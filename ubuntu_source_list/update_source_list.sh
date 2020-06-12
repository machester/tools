#!/bin/bash
# echo "---> need root password"
# retry=0
# while [ $retry -lt 3 ]
# do
#     let retry++;
#     su
#     if [ $? ]; then
#         echo "---> password error, retry $retry"
        
#     else
#         break
#     fi
# done

# if [ $retry -lt 3 ]; then
#     echo "---> start update source list in 3 seconds, ctrl+c for stop"
# else
#     echo "---> password error stop bash"
#     exit 0
# fi

echo "---> start update source list in 2 seconds, ctrl+c for stop"
sleep 2s
sudo cp -vf /etc/apt/sources.list  /etc/apt/sources.list_backup
echo "# aliyun source list" | sudo tee /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list

echo "---> source list file updated, ready to update apt source list"
sleep 1s

sudo apt update

echo "---> finished"
exit 0
