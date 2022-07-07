#!/bin/bash

git clone https://github.com/fatedier/frp.git

if [ $? -eq 0 ];then
    echo "download pass"
else
    echo "download failed"
fi