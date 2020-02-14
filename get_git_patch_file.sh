#!/bin/bash

function usage()
{
    echo "----------------------- usage ---------------------------------------"
    echo " ./<bash_file>.sh <path to get path file> <path to store patch file>"
    echo "./<bash_file>.sh default mode "
    echo "---------------------------------------------------------------------"
    exit
}

echo "---> start  get patch"
if [ "$1" == "default" ]; then
    echo "---> default mode choosed, patch linux-yocto"
    PATCH_FLD=/home/jiangq/work2/work/MTK/linux-yocto
    SOURCE_FLD=/home/jiangq/work2/work/MTK/linux-yocto/src/kernel/linux/v4.4_mt8183
elif [ $# -eq 2 ]; then
    PATCH_FLD=$2
    SOURCE_FLD=$1
elif [ $# -lt 2 ]; then
    usage
fi

CUR_FLD=`pwd`

cd $SOURCE_FLD
echo "---> moved in: $SOURCE_FLD"

git branch > branch.log
if [ $? -ne 0 ]; then
    echo "---> git branch not found"
    exit
fi
echo "----------------- current git branch -----------------"
cat branch.log
echo "------------------------------------------------------"
sed -i 's/* //g' branch.log
cat branch.log | while read items
do
    BRANCH_NAME=$items
    echo "branch name: $BRANCH_NAME"
done
sleep 2s

git status > git_modified.log
# delete last line
sed -i '$d' git_modified.log
# delete 1~5 line
sed -i '1,5d' git_modified.log
# delete empty line
sed -i '/^$/d' git_modified.log
# delete line which has charaters <Untracked>
sed -in '/'Untracked'/d' git_modified.log
# delete line which has charaters <git add>
sed -in '/'git\ add'/d' git_modified.log
##########################################################################################
# git status > log.log &&  grep -ns "modified" log.log | tee git_modified.log
# if [ $? -ne 0 ]; then
#     echo "---> git status not completed"
#     exit
# fi
##########################################################################################
# sed 's/<old_str>/<new_str>/g' <source_file>
sed -i 's/modified://g' git_modified.log
cat git_modified.log
DATE=$(date  +%Y%m%d_%H%M%S)
mkdir -p $PATCH_FLD/PATCH/PATCH_$BRANCH_NAME$DATE
cat git_modified.log | while read items
do
    cp --parents -ravf $SOURCE_FLD/$items $PATCH_FLD/PATCH/PATCH_$BRANCH_NAME_$DATE
    #sleep 1s
done

echo "----------------- clean log -------------------"
rm -vf branch.log
rm -vf git_modified.log
rm -vf git_modified.logn
echo "----------------- clean log -------------------"
exit