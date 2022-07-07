#!/bin/bash






#!/bin/bash

echo "download frp..."
bash ../frp_tools/frp_download.sh
if [ $? -ne 0 ]; then
    echo "download failed"
fi

