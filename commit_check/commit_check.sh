#!/bin/bash

#####################################################################################
# 1. 检测是否有有效改动，且有效改动已经添加到提交暂存区
# 2. 提交类型：1.bugfix 2.new_feature 3.revert 4.feature_upgrade 5.merge
# 3. 检查文件编码格式

DETAIL=""
COMMENT="please choose the type: 1. bugfix 2. new_feature 3.feature_upgrade 4.revert 5.merge"

REASON=""

CUR_DIR=`pwd`
# COMMIT_TEMPLATE=""$CUR_DIR"/.git/hooks/commit_format_template.txt"
COMMIT_TEMPLATE=""$CUR_DIR"/commit_format_template.txt"
COMMIT_FILE=$CUR_DIR/commit.txt
TEMP_FILE=$CUR_DIR/tmp.txt
LOG_FILE=$CUR_DIR/commit_log.log

echo "--------------------- pre-commit check start ----------------------------"

# touch $LOG_FILE

NEED_TEMPLATE=false
DEBUG_EN_MARK=false

BUGFIX_MARK="Bug Fix:"
NEW_FEATURE_MARK="New Feature:"
FEATURE_UPGRADE_MARK="Feature Upgrade:"
REVERT_MARK="Revert:"
MERGE_MARK="Merge:"
DIVID_MARKK="======"
EMPTY_LINE="------"

ZENTAO_MARK="Zen Tao:"
MTK_CR_MARK="MTK CR:"
ZHANRUI_CQ_MARK="UNISOC CQ:"
DESCRIPTION_MARK="Detail Descriptions:"
WHY_MARK="Why:"
HOW_MARK="How:"
OPETION_MARK="Operations:"
CHANGE_ID_MARK="Change-Id:"
SIGNED_OFF_MARK="Signed-off-by:"

COMMIT_MSG_CONTAINER=""

COMMIT_FOR_BUGFIX=false
COMMENT_FOR_NEW_FEATURE=false
COMMENT_FOR_FEATURE_UPGRADE=false
COMMENT_FOR_REVERT=false
COMMENT_FOR_MERGE=false



# echo "CUR_DIR:"$CUR_DIR
# echo "COMMIT_TEMPLATE:"$COMMIT_TEMPLATE
# echo "LOG_FILE"$LOG_FILE
#####################################################################################

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

###################################################################################################


function help()
{
	echo "--------------------------------- BASIC RULES NOTICE -----------------------------------------"
	echo "detail of basic rules"
	echo "----------------------------------------------------------------------------------------------"
	exit
}

function commit_file_format()
{
	echo "--------------------------------- COMMIT FILE FORMAT NOTICE ----------------------------------"
	echo "detail of commit format"
	echo "-----------------------------------------------------------------------------------------------"
	exit
}


function param_check()
{
	echo "------------------------------------"
	echo "COMMIT_TEMPLATE:"$COMMIT_TEMPLATE
	if [  ! -f "$COMMIT_TEMPLATE" ]
	then
		echo "formate template file missing"
	fi
	if [ ! -s "$COMMIT_TEMPLATE" ]
	then
		echo "formate template file is empty"
	else
		echo "param check pass..."
	fi
}


function create_template()
{
	# echo "---> in create_template"
	if [   -f "$COMMIT_FILE" ]
	then
		read -r  -p "you have a commit txt file in: $COMMIT_FILE Do you want to use? [y/n]" input
		case $input in
			[yY][eE][sS]|[yY])
			commit_msg_check
			TEMPLATE_REPORT=true
			;;
			[nN][oO]|[nN])
			echo "not use exisit commit file"
			rm -vf $COMMIT_FILE
			TEMPLATE_REPORT=false
			;;
			*)
			echo "default not use exisit commit file"
			rm -vf $COMMIT_FILE
			commit_msg_check
			TEMPLATE_REPORT=false
		esac
	else
		read -r  -p "do you need template? [y/n]" input
		case $input in
			[yY][eE][sS]|[yY])
			touch $COMMIT_FILE
			echo "Commit template create on: "$COMMIT_FILE
			NEED_TEMPLATE=true
			;;
			[nN][oO]|[nN])
			echo "no need template..."
			NEED_TEMPLATE=false
			;;
			*)
			echo "don't need need template"
			NEED_TEMPLATE=false
		esac
	fi

	if [ "$COMMIT_FOR_BUGFIX" = true ] && [ "$NEED_TEMPLATE" = true ]
	then
		echo "BUGFIX_MARK: "$BUGFIX_MARK
		START_LINE=`sed -n "/$BUGFIX_MARK/=" $COMMIT_TEMPLATE`
		# echo "START_LINE: "$START_LINE
		SEARCH_RANGE=`echo $((START_LINE+50))`
		sed -ne "$START_LINE,$SEARCH_RANGE p" $COMMIT_TEMPLATE | sed -n "/$DIVID_MARKK/=" | sed -n "1"p
		STOP_LINE=`sed -ne "$START_LINE,$SEARCH_RANGE p" $COMMIT_TEMPLATE | sed -n "/$DIVID_MARKK/=" | sed -n "1"p`
		echo "STOP_LINE: "$STOP_LINE
		PRINT_ENDLINE=`echo $((START_LINE+STOP_LINE-2))`
		echo "======================================================"
		sed -ne "$START_LINE,$PRINT_ENDLINE p" $COMMIT_TEMPLATE | tee $COMMIT_FILE
		echo "======================================================"
		echo "commit template has done store in: "$COMMIT_FILE
		exit
	elif [ "$COMMENT_FOR_NEW_FEATURE" = true ] && [ "$NEED_TEMPLATE" = true ]
	then
		echo "NEW_FEATURE_MARK: "$NEW_FEATURE_MARK
		START_LINE=`sed -n "/$NEW_FEATURE_MARK/=" $COMMIT_TEMPLATE`
		# echo "START_LINE: "$START_LINE
		SEARCH_RANGE=`echo $((START_LINE+50))`
		sed -ne "$START_LINE,$SEARCH_RANGE p" $COMMIT_TEMPLATE | sed -n "/$DIVID_MARKK/=" | sed -n "1"p
		STOP_LINE=`sed -ne "$START_LINE,$SEARCH_RANGE p" $COMMIT_TEMPLATE | sed -n "/$DIVID_MARKK/=" | sed -n "1"p`
		echo "STOP_LINE: "$STOP_LINE
		PRINT_ENDLINE=`echo $((START_LINE+STOP_LINE-2))`
		echo "======================================================"
		sed -ne "$START_LINE,$PRINT_ENDLINE p" $COMMIT_TEMPLATE | tee $COMMIT_FILE
		echo "======================================================"
		echo "commit template has done store in: "$COMMIT_FILE
		exit
	elif [ "$COMMENT_FOR_FEATURE_UPGRADE" = true ] && [ "$NEED_TEMPLATE" = true ]
	then
		echo "FEATURE_UPGRADE_MARK: "$FEATURE_UPGRADE_MARK
		echo "COMMIT_TEMPLATE: "$COMMIT_TEMPLATE
		START_LINE=`sed -n "/$FEATURE_UPGRADE_MARK/=" $COMMIT_TEMPLATE`
		# echo "START_LINE: "$START_LINE
		SEARCH_RANGE=`echo $((START_LINE+50))`
		sed -ne "$START_LINE,$SEARCH_RANGE p" $COMMIT_TEMPLATE | sed -n "/$DIVID_MARKK/=" | sed -n "1"p
		STOP_LINE=`sed -ne "$START_LINE,$SEARCH_RANGE p" $COMMIT_TEMPLATE | sed -n "/$DIVID_MARKK/=" | sed -n "1"p`
		echo "STOP_LINE: "$STOP_LINE
		PRINT_ENDLINE=`echo $((START_LINE+STOP_LINE-2))`
		echo "======================================================"
		sed -ne "$START_LINE,$PRINT_ENDLINE p" $COMMIT_TEMPLATE | tee $COMMIT_FILE
		echo "======================================================"
		exit
		echo "commit template has done store in: "$COMMIT_FILE
	elif [ "$COMMENT_FOR_REVERT" = true ] && [ "$NEED_TEMPLATE" = true ]
	then
		echo "REVERT_MARK: "$REVERT_MARK
		echo "COMMIT_TEMPLATE: "$COMMIT_TEMPLATE
		START_LINE=`sed -n "/$REVERT_MARK/=" $COMMIT_TEMPLATE`
		# echo "START_LINE: "$START_LINE
		SEARCH_RANGE=`echo $((START_LINE+50))`
		STOP_LINE=`sed -ne "$START_LINE,$SEARCH_RANGE p" $COMMIT_TEMPLATE | sed -n "/$DIVID_MARKK/=" | sed -n "1"p`
		echo "STOP_LINE: "$STOP_LINE
		PRINT_ENDLINE=`echo $((START_LINE+STOP_LINE-2))`
		echo "======================================================"
		sed -ne "$START_LINE,$PRINT_ENDLINE p" $COMMIT_TEMPLATE | tee $COMMIT_FILE
		echo "======================================================"
		echo "commit template has done store in: "$COMMIT_FILE
		exit
	elif [ "$COMMENT_FOR_MERGE" = true ] && [ "$NEED_TEMPLATE" = true ]
	then
		echo "MERGE_MARK: "$MERGE_MARK
		echo "COMMIT_TEMPLATE: "$COMMIT_TEMPLATE
		START_LINE=`sed -n "/$MERGE_MARK/=" $COMMIT_TEMPLATE`
		# echo "START_LINE: "$START_LINE
		SEARCH_RANGE=`echo $((START_LINE+50))`
		STOP_LINE=`sed -ne "$START_LINE,$SEARCH_RANGE p" $COMMIT_TEMPLATE | sed -n "/$DIVID_MARKK/=" | sed -n "1"p`
		echo "STOP_LINE: "$STOP_LINE
		PRINT_ENDLINE=`echo $((START_LINE+STOP_LINE-2))`
		echo "======================================================"
		sed -ne "$START_LINE,$PRINT_ENDLINE p" $COMMIT_TEMPLATE | tee $COMMIT_FILE
		echo "======================================================"
		echo "commit template has done store in: "$COMMIT_FILE
		exit
	else
		if [ "$TEMPLATE_REPORT" = true ]
		then
			echo "use template report..."
		else
			echo "don't need template"
			rm -vf $COMMIT_FILE
		fi
	fi
}

function commit_msg_check()
{
	echo "commit_msg_check..."

	# read -r  -p "" input
	# case $input in
	# 	[yY][eE][sS]|[yY])
	# 	commit_msg_check
	# 	;;
	# 	[nN][oO]|[nN])
	# 	echo "not use exisit commit file"
	# 	rm -vf $COMMIT_FILE
	# 	;;
	# 	*)
	# 	echo "default not use exisit commit file"
	# 	rm -vf $COMMIT_FILE
		
	# esac
}

MSG_VAL=""

function check_value_is_empty()
{
	# echo "check if read value is empty"
	echo $MSG_VAL
	if [ ! -n "$MSG_VAL" ]
	then
		echo "error: format "
		exit 1
	fi
}

function do_commmit()
{
	# echo "---> do commit"
	echo "================================================"
	cat $TEMP_FILE
	echo "================================================"
	COMMENT_MSG=`cat $TEMP_FILE`
	git commit -sm "$COMMENT_MSG"
}

function do_bugfix()
{
	echo "---> in do_bugfix"
	TYPE=$BUGFIX_MARK

	create_template

	if [ "$COMMIT_FOR_BUGFIX" = true ] && [ "$TEMPLATE_REPORT" = true ]
	then
		## create temp file
		rm -vf $TEMP_FILE
		touch $TEMP_FILE
		## format and find Bug Fix
		START_LINE=`sed -n "/$BUGFIX_MARK/=" $COMMIT_FILE`
		# echo "START_LINE: "$START_LINE

		if [ ! -n "$START_LINE" ]
		then
			echo "error: format "$BUGFIX_MARK
			exit
		elif [ $START_LINE -gt 1 ]
		then
			echo $BUGFIX_MARK" not start from line 1 do format"
			CORRECT_LINE=`echo $((START_LINE-1))`
			echo "CORRECT_LINE: "$CORRECT_LINE
			sed -i "1,$CORRECT_LINE d" $COMMIT_FILE
		elif [ $START_LINE == 1 ]
		then
			echo $BUGFIX_MARK" check head mark pass"
		else
			echo "error: format "$BUGFIX_MARK
			exit
		fi
		
		TAG_HEAD=`sed -ne "1 p" $COMMIT_FILE`
		COMMIT_MSG_CONTAINER=`echo -e "$TAG_HEAD\n"`
		echo $COMMIT_MSG_CONTAINER | tee -a $TEMP_FILE
		MSG_VAL=`grep -hw "$BUGFIX_MARK" $COMMIT_FILE | awk -F ":" '{print $2}' | sed s/[[:space:]]//g`
		check_value_is_empty
		
		## find Zen Tao
		START_LINE=`sed -n "/$ZENTAO_MARK/=" $COMMIT_FILE`
		# echo "START_LINE: "$START_LINE

		if [ ! -n "$START_LINE" ]
		then
			echo "error: format "$ZENTAO_MARK
			exit
		fi
		TAG_ZENTAO=`grep -hw "$ZENTAO_MARK" $COMMIT_FILE`
		COMMIT_MSG_CONTAINER=`echo -e "$TAG_ZENTAO\n"`
		echo $COMMIT_MSG_CONTAINER | tee -a $TEMP_FILE

		## find MTK CR
		START_LINE=`sed -n "/$MTK_CR_MARK/=" $COMMIT_FILE`
		# echo "START_LINE: "$START_LINE

		if [ ! -n "$START_LINE" ]
		then
			echo "error: format "$MTK_CR_MARK
			exit
		fi
		TAG_MTK_CR=`grep -hw "$MTK_CR_MARK" $COMMIT_FILE`
		COMMIT_MSG_CONTAINER=`echo -e "$TAG_MTK_CR\n"`
		echo $COMMIT_MSG_CONTAINER | tee -a $TEMP_FILE

		## find Zhan Rui CQ
		START_LINE=`sed -n "/$ZHANRUI_CQ_MARK/=" $COMMIT_FILE`
		# echo "START_LINE: "$START_LINE

		if [ ! -n "$START_LINE" ]
		then
			echo "error: format "$ZHANRUI_CQ_MARK
			exit
		fi
		TAG_ZHANRUI_CQ=`grep -hw "$ZHANRUI_CQ_MARK" $COMMIT_FILE`
		COMMIT_MSG_CONTAINER=`echo -e "$TAG_ZHANRUI_CQ\n"`
		echo $COMMIT_MSG_CONTAINER | tee -a $TEMP_FILE
		COMMIT_MSG_CONTAINER=`echo -e "\n"`
		echo $COMMIT_MSG_CONTAINER | tee -a $TEMP_FILE

		## find Detail Descriptions:
		START_LINE=`sed -n "/$DESCRIPTION_MARK/=" $COMMIT_FILE`
		# echo "START_LINE: "$START_LINE

		if [ ! -n "$START_LINE" ]
		then
			echo "error: format "$DESCRIPTION_MARK
			exit
		fi

		TAG_DESCRIPTION=`grep -hw "$DESCRIPTION_MARK" $COMMIT_FILE | awk -F ":" '{print $1}'`
		COMMIT_MSG_CONTAINER=`echo -e "$TAG_DESCRIPTION:\n"`
		echo $COMMIT_MSG_CONTAINER | tee -a $TEMP_FILE

		## Search all Detaill Description info
		WHY_LINE=`sed -n "/$WHY_MARK/=" $COMMIT_FILE`
		DESC_START_LINE=`echo $((START_LINE+1))`
		DESC_END_LINE=`echo $((WHY_LINE-1))`
		
		COMMIT_MSG_CONTAINER=`sed -ne "$DESC_START_LINE,$DESC_END_LINE p" $COMMIT_FILE`
		echo -e "\t$COMMIT_MSG_CONTAINER" | tee -a $TEMP_FILE
		MSG_VAL=`sed -ne "$DESC_START_LINE,$DESC_END_LINE p" $COMMIT_FILE | sed s/[[:space:]]//g`
		check_value_is_empty

		COMMIT_MSG_CONTAINER=`echo -e "\n"`
		echo -e "\t$COMMIT_MSG_CONTAINER" | tee -a $TEMP_FILE

		## find why:
		START_LINE=`sed -n "/$WHY_MARK/=" $COMMIT_FILE`
		# echo "START_LINE: "$START_LINE

		if [ ! -n "$START_LINE" ]
		then
			echo "error: format "$WHY_MARK
			exit
		fi

		TAG_WHY=`grep -hw "$WHY_MARK" $COMMIT_FILE | awk -F ":" '{print $1}'`
		COMMIT_MSG_CONTAINER=`echo -e "$TAG_WHY:\n"`
		echo $COMMIT_MSG_CONTAINER | tee -a $TEMP_FILE
		
		## search why Description info
		HOW_LINE=`sed -n "/$HOW_MARK/=" $COMMIT_FILE`
		if [ ! -n "$HOW_LINE" ]
		then
			echo "error: find"$HOW_MARK
			echo "     get $WHY_MARK failed"
			exit
		fi

		WHY_INFO_START_LINE=`echo $((WHY_LINE+1))`
		WHY_INFO_END_LINE=`echo $((HOW_LINE-1))`

		COMMIT_MSG_CONTAINER=`sed -ne "$WHY_INFO_START_LINE,$WHY_INFO_END_LINE p" $COMMIT_FILE`
		echo -e "\t$COMMIT_MSG_CONTAINER" | tee -a $TEMP_FILE

		## find how:
		TAG_HOW=`grep -hw "$HOW_MARK" $COMMIT_FILE | awk -F ":" '{print $1}'`
		COMMIT_MSG_CONTAINER=`echo -e "$TAG_HOW:\n"`
		echo $COMMIT_MSG_CONTAINER | tee -a $TEMP_FILE
		
		## search how Description info
		CHANGE_ID_MARK_LINE=`sed -n "/$CHANGE_ID_MARK/=" $COMMIT_FILE`
		# echo "---> CHANGE_ID_MARK_LINE: "$CHANGE_ID_MARK_LINE
		if [ ! -n "$CHANGE_ID_MARK_LINE" ]
		then
			echo "error: find"$CHANGE_ID_MARK_LINE
			echo "     get $CHANGE_ID_MARK failed"
			exit
		fi
		HOW_INFO_START_LINE=`echo $((HOW_LINE+1))`
		HOW_INFO_END_LINE=`echo $((CHANGE_ID_MARK_LINE-1))`

		COMMIT_MSG_CONTAINER=`sed -ne "$HOW_INFO_START_LINE,$HOW_INFO_END_LINE p" $COMMIT_FILE`
		echo -e "\t$COMMIT_MSG_CONTAINER" | tee -a $TEMP_FILE
		COMMIT_MSG_CONTAINER=`echo -e "\n"`
		echo -e "\t$COMMIT_MSG_CONTAINER" | tee -a $TEMP_FILE
		
		## find Change ID:
		TAG_CHANGE_ID=`grep -hw "$CHANGE_ID_MARK" $COMMIT_FILE | awk -F ":" '{print $1}'`
		COMMIT_MSG_CONTAINER=`echo -e "$CHANGE_ID_MARK\n"`
		echo $COMMIT_MSG_CONTAINER | tee -a $TEMP_FILE
		
		## search Change ID Description info
		SIGNED_OFF_LINE=`sed -n "/$SIGNED_OFF_MARK/=" $COMMIT_FILE`
		# echo "---> SIGNED_OFF_LINE: "$SIGNED_OFF_LINE
		if [ ! -n "$SIGNED_OFF_LINE" ]
		then
			echo "error: find"$SIGNED_OFF_LINE
			echo "     get $CHANGE_ID_MARK failed"
			exit
		fi
		CHANGE_ID_INFO_START_LINE=`echo $((CHANGE_ID_MARK_LINE+1))`
		CHANGE_ID_INFO_END_LINE=`echo $((SIGNED_OFF_LINE-1))`

		COMMIT_MSG_CONTAINER=`sed -ne "$CHANGE_ID_INFO_START_LINE,$CHANGE_ID_INFO_END_LINE p" $COMMIT_FILE`
		echo -e "\t$COMMIT_MSG_CONTAINER" | tee -a $TEMP_FILE

		## find Signed-off:
		TAG_SIGNED_OFF=`grep -hw "$SIGNED_OFF_MARK" $COMMIT_FILE | awk -F ":" '{print $1}'`
		COMMIT_MSG_CONTAINER=`echo -e "$SIGNED_OFF_MARK\n"`
		echo $COMMIT_MSG_CONTAINER | tee -a $TEMP_FILE
		
		SIGNED_OFF_INFO_START_LINE=`echo $((SIGNED_OFF_LINE+1))`
		SIGNED_OFF_INFO_END_LINE=`echo $((50-1))`

		COMMIT_MSG_CONTAINER=`sed -ne "$SIGNED_OFF_INFO_START_LINE,$SIGNED_OFF_INFO_END_LINE p" $COMMIT_FILE`
		echo -e "\t$COMMIT_MSG_CONTAINER" | tee -a $TEMP_FILE
		## commit msg

	else

		echo "please enter the NO. of zentao, if you have, it is necessary, if not, enter n or N"
		read ZENTAO
		echo "please do a brief description of this bug"
		read BRIEF
		echo "please describe this bug in detail"
		read DETAIL
		echo "please explain the reason of this bug"
		read REASON
		echo "please describe the way how you solve the bug"
		read WHY
		echo "please enter the options of this bug"
		read OPTIONS

		if [ "$ZENTAO"x != "n"x -a "$ZENTAO"x != "N"x ]
		then
			COMMENT="[$TYPE][$ZENTAO] $BRIEF"
		else
			COMMENT="[$TYPE] $BRIEF"
		fi

		COMMENT=""$COMMENT"\n\n[what] "$DETAIL""
		COMMENT=""$COMMENT"\n[why] "$REASON""
		COMMENT=""$COMMENT"\n[how] "$WHY""
		COMMENT=""$COMMENT"\n[options] "$OPTIONS""
		COMMENT=`echo -e "$COMMENT"`
		echo $COMMENT > $TEMP_FILE


		##########################################################################################
		# echo "please enter the NO. of zentao, if you have, it is necessary, if not, enter n or N"
		# read ZENTAO
		# echo "please do a brief description of this bug"
		# read BRIEF
		# echo "please describe this bug in detail"
		# read DETAIL
		# echo "please explain the reason of this bug"
		# read REASON
		# echo "please describe the way how you solve the bug"
		# read WHY
		# echo "please enter the options of this bug"
		# read OPTIONS
		# if [ "$ZENTAO"x != "n"x -a "$ZENTAO"x != "N"x ]
		# then
		# 	COMMENT="[$TYPE][$ZENTAO] $BRIEF"
		# else
		# 	COMMENT="[$TYPE] $BRIEF"
		# fi
		# COMMENT=""$COMMENT"\n\n[what] "$DETAIL""
		# COMMENT=""$COMMENT"\n[why] "$REASON""
		# COMMENT=""$COMMENT"\n[how] "$WHY""
		# COMMENT=""$COMMENT"\n[options] "$OPTIONS""
		# COMMENT=`echo -e "$COMMENT"`
		
	fi
	# echo "================================================================"
	# cat $TEMP_FILE
	# echo "================================================================"
	do_commmit
	rm -vf $TEMP_FILE
	exit
}

function do_new_feature()
{
	create_template
}

function do_feature_upgrade()
{
	echo "-------- do_feature_upgrade "
	create_template
}

function do_revert()
{
	
	echo "-------- do_revert "
	create_template
}

function do_merge()
{
	echo "-------- do_merge "
	create_template
}

param_check


while [ ""x = ""x ]
do
	echo $COMMENT
	read INPUT
	case $INPUT in
		1)
			echo "do_bugfix"
			COMMIT_FOR_BUGFIX=true
			do_bugfix
			break;;
		2)
			COMMENT_FOR_NEW_FEATURE=true
			do_new_feature
			break;;
		3)
			COMMENT_FOR_FEATURE_UPGRADE=true
			do_feature_upgrade
			break;;
		4)
			COMMENT_FOR_REVERT=true
			do_revert
			break;;
		5)
			COMMENT_FOR_MERGE=true
			do_merge
			break;;
		?)
			help
			break;;
	esac
done

git commit -sm "$COMMENT"

echo "--------------------- pre-commit check end ----------------------------"
