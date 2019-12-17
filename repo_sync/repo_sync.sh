#!/bin/bash

trap 'onCtrlC' INT
function onCtrlC () {
    echo "manual stopped"
    exit
}

echo "-------------- start sync --------------"
repo sync -c --no-clone-bundle
while [ $? -ne 0 ]; 
do  
    repo sync -c --no-clone-bundle -j8
done
echo "------------- sync finished -------------"
