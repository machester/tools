#!/bin/bash






#!/bin/bash

FRP_DIR=$(pwd)
echo "---> cur dir: $FRP_DIR"

FRP_TOOLS_DIR=$FRP_DIR/frp_tools


echo "download frp..."
bash $FRP_DIR/frp_download.sh
if [ $? -ne 0 ]; then
    echo "download failed"
fi

cp -vf $FRP_DIR/frp_v0.43.0_linux_amd64.tar.gz .
tar -xvf frp_v0.43.0_linux_amd64.tar.gz

cd frp_0.43.0_linux_amd64