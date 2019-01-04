#!/bin/bash

echo "---------------- remove hidden file -------------------------"
echo "---> ready to remove all files start with "._" in 3 seconds"
sleep 3s
rm -vf `find ./ -name "._*"` | tee remove.log
