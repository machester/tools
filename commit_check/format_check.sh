#!/bin/bash

# 1. 检测是否有有效改动，且有效改动已经添加到提交暂存区
# 2. 执行 python 程序对文件进行格式检查
CUR_DIR=`pwd`
# COMMIT_TEMPLATE=""$CUR_DIR"/.git/hooks/commit_format_template.txt"
COMMIT_TEMPLATE=""$CUR_DIR"/commit_format_template.txt"
COMMIT_FILE=$CUR_DIR/commit.txt
TEMP_FILE=$CUR_DIR/tmp.txt
LOG_FILE=$CUR_DIR/commit_log.log


if git rev-parse --verify HEAD >/dev/null 2>&1
then
	against=HEAD
else
	# Initial commit: diff against an empty tree object
	against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

allownonascii=$(git config --bool hooks.allownonascii)

exec 1>&2

if [ "$allownonascii" != "true" ] &&
	test $(git diff --cached --name-only --diff-filter=A -z $against |
	  LC_ALL=C tr -d '[ -~]\0' | wc -c) != 0
then
	cat <<\EOF
	Error: Attempt to add a non-ASCII file name.

	This can cause problems if you want to work with people on other platforms.

	To be portable it is advisable to rename the file.

	If you know what you are doing you can disable this check using:

	git config hooks.allownonascii true
EOF
	exit 1
fi

# If there are whitespace errors, print the offending file names and fail.
git diff-index --check --cached $against --
# exec git diff-index --check --cached $against --
echo "---> run return value:" $?

### do python program check
python3 format_check.py

if [ $? -ne 0 ]
then
    echo "---------------------------------- format check failed ! ----------------------------------"
else 
    echo "---------------------------------- commit pass ----------------------------------"
fi
#################################### END LINE ####################################
