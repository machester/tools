#!/bin/bash

# release link: https://github.com/fatedier/frp/releases/tag/
wget https://github.com/fatedier/frp/releases/tag/v0.43.0/frp_v0.43.0_linux_amd64.tar.gz

if [ $? -eq 0 ];then
    echo "download pass"
else
    echo "download failed"
fi