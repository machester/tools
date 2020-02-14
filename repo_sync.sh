#!/bin/bash

trap 'onCtrlC' INT
function onCtrlC () {
    echo "manual stopped"
    exit
}

echo "-------------- start sync --------------"
repo sync -j8 
while [ $? -ne 0 ]; 
do 
    echo "----------------- retry --------------" 
    repo sync -j8
done
echo "------------- sync finished -------------"
