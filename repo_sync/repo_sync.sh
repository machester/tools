#!/bin/bash

echo "-------------- start sync --------------"
repo sync -c --no-clone-bundle
while [ $? -ne 0 ]; 
do  
    repo sync -c --no-clone-bundle
done
echo "------------- sync finished -------------"
