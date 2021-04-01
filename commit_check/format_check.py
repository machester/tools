# -*- coding: utf-8 -*-
############################################# Description #############################################
#
#
#######################################################################################################

import os
import subprocess
import linecache


# encode, decode
# import chardet


VERSION = "1.1"
UPGRADE_DATE = "2021-04-01"

# template_file_path = cur_work_abs_path + "/commit_format_template.txt"
# commit_file_path = cur_work_abs_path + "/commit.txt"

cur_work_abs_path = os.path.abspath ( '.' )

# for test
commit_file_name = "commit.txt"
template_file_path = cur_work_abs_path + "/commit_format_template.txt"
commit_file_path = ""

DIVID_MARK = "======"
VALUE_CUT_MARK = ":"

MINI_INFO_LEN = 3

COMMENT = "please choose the type: 1. Bug Fix 2. New Feature 3.Feature Upgrade 4.Revert 5.Merge"

commit_type_dic = { "1": "Bug Fix",
                    "2": "New Feature",
                    "3": "Feature Upgrade",
                    "4": "Revert",
                    "5": "Merge"
                    }


help_info_container_dic = {
	"help" : "\
-------------------------------------------- HELP ----------------------------------------------\n\
------------------------------------------------------------------------------------------------",
	"notic": "\
-------------------------------------------- NOTICE --------------------------------------------\n\
------------------------------------------------------------------------------------------------"
}

commit_msg_container_dic_for_common_type = {
	"Zen Tao"  : "nope",
	"MTK CR"   : "nope",
	"UNISOC CQ": "nope"
}

commit_msg_container_dic_for_bug_fix = {
	"Bug Fix"               : "nope",
	"Detail Descriptions"   : "nope",
	"Why"                   : "nope",
	"How"                   : "nope",
	"Associated Branch Path": "nope"
}

commit_msg_container_dic_for_new_feature = {
	"New Feature"           : "nope",
	"Detail Descriptions"   : "nope",
	"Options"               : "nope",
	"Associated Branch Path": "nope"
}

commit_msg_container_dic_for_feature_upgrade = {
	"Feature Upgrade"       : "nope",
	"Detail Descriptions"   : "nope",
	"Why"                   : "nope",
	"How"                   : "nope",
	"Options"               : "nope",
	"Associated Branch Path": "nope",
	"Affected Submission Id": "nope"
}

commit_msg_container_dic_for_revert = {
	"Revert"                : "nope",
	"Detail Descriptions"   : "nope",
	"Why"                   : "nope",
	"How"                   : "nope",
	"Associated Branch Path": "nope"
}

commit_msg_container_dic_for_merge = {
	"Merge"                 : "nope",
	"Detail Descriptions"   : "nope",
	"Options"               : "nope",
	"Associated Branch Path": "nope",
}

skip_commit_mark_list = [ "n", "nc", "empty" , "--- n", "---n"]

cmit_msg = "\n"
current_commit_type = ""
template_msg_mark = "Info:"


def do_shell_cmd( shell_cmd ):
	try:
		res = subprocess.Popen ( shell_cmd, shell = True, stdin = subprocess.PIPE, stdout = subprocess.PIPE,
				stderr = subprocess.PIPE )
		lines = res.stdout.read ( )  # read cmd ouput
		lines.decode ( 'utf-8' )  # decode
		res.wait ( )  # wait cmd
		res.stdout.close ( )  # close std out
		return lines
	except BaseException as e:
		print ( "error: shell cmd: " + shell_cmd )
		return (-1)


def store_info_to_param( msg_key, msg_value, value_store_nextline = False ):
	global cmit_msg
	cmit_msg += msg_key + ": "
	if value_store_nextline:
		cmit_msg += "\n\t"
	cmit_msg += msg_value.strip ( )
	cmit_msg += "\n"


def is_file_exist( path_name ):
	try:
		if not (os.path.exists ( path_name )):
			# print ( "not exist" )
			return False
		else:
			# print ( "exist" )
			return True
	except FileNotFoundError:
		print ( "error: path name or format" )
		return LookupError


def read_and_print_file( path_name ):
	with open ( path_name, "rt", encoding = "UTF-8" ) as fp:
		print ( "============================== INFORMATION ==============================" )
		for line_data in fp:
			print ( line_data.strip ( ) )  # readline and delete last '\n'
		print ( "=========================================================================" )


def do_commit( commit_message ):
	# print("-------------------------------------- COMMIT MSG --------------------------------------")
	# print(commit_message)
	# print("----------------------------------------------------------------------------------------")
	tmp_shell_cmd = "git commit -sm \"" + commit_message + "\""
	ret_val = do_shell_cmd ( tmp_shell_cmd )
	if (-1 != ret_val):
		print ( "\n--------------------- commit finished ---------------------\n" )
		return True
	else:
		return False


def force_decode_to_uft8( args ):
	# TODO:
	return True


def format_commit_file( file_path ):
	# format commit.txt file
	# delete space
	# encode check TODO:

	tmp_shell_cmd = "sed -i 's/^[[:space:]]*//' " + commit_file_path
	ret_val = do_shell_cmd ( tmp_shell_cmd )
	if (-1 == ret_val):
		return False
	# delete head empyty line
	tmp_shell_cmd = "sed -i '/^$/d' " + commit_file_path
	ret_val = do_shell_cmd ( tmp_shell_cmd )
	if (-1 == ret_val):
		return False
	return True


def find_repo_path_create_commit_file_path( ):
	global commit_file_path
	tmp_path = cur_work_abs_path
	"""find .repo"""
	dir_var_list = tmp_path.split ( "/" )
	dir_deep_index = len ( dir_var_list )
	dir_loop_ticks = len ( dir_var_list )
	index = 0
	while index < int ( len ( dir_var_list ) ):
		index += 1
		dir_deep_index = dir_deep_index - 1
		# print("tmp_path:" + tmp_path)
		dir_list = os.listdir ( tmp_path )
		for dirs in dir_list:
			if ".repo" == dirs:
				commit_file_path = tmp_path
				dir_deep_index = 0
				break

		if (len ( commit_file_path.strip ( ) ) > 0):
			print ( "find .repo in path: [" + commit_file_path + "]" )
			commit_file_path = commit_file_path + "/" + commit_file_name
			return True
		else:
			# print("dir_var_list[" + str(dir_deep_index) + "] = " + dir_var_list[dir_deep_index])
			tmp_path = tmp_path.rstrip ( dir_var_list[ dir_deep_index ] )
			tmp_path = tmp_path.rstrip ( "/" )
			if (len ( tmp_path.strip ( ) ) <= 0):
				break
		# print("---> tmp_path: " + tmp_path)
	return False


# TODO: find a fast way to find .repo
# """find git"""
# git_tmp_file_path = cur_work_abs_path + "/git_tmp.txt"
# tmp_shell_cmd = "git status > " + git_tmp_file_path
# do_shell_cmd(tmp_shell_cmd)
#
# with open ( file_path, "rt", encoding = "UTF-8" ) as fp:
# 	for line_index, data in enumerate ( fp, start = 1 ):
# 		data.strip ( )
# 		find_result = data.find ( "fatal" )
# if find_result > 0:
# 	print("not  in git dir")
# else:
# 	print("got git dir")


# return a string list, start with line next is value without start_mark
# tag and information on same line

def got_not_must_check_info( file_path ):
	tmp_list = [ "nope", "empty" ]
	found_value_flag = False

	with open ( file_path, "rt", encoding = "UTF-8" ) as fp:
		for line_index, data in enumerate ( fp, start = 1 ):
			data.strip ( )
			value_start_position = data.find ( VALUE_CUT_MARK )
			report_info_mark = data[ 0: value_start_position ]
			report_info_mark_value = data[ (value_start_position + 1): ]
			# remove left and right space
			report_info_mark_value = report_info_mark_value.strip ( )

			# store value
			for comm_key in commit_msg_container_dic_for_common_type.keys ( ):
				if comm_key == report_info_mark:
					commit_msg_container_dic_for_common_type[ report_info_mark ] = report_info_mark_value

	# check if all items got data
	for dic_key, dic_value in commit_msg_container_dic_for_common_type.items ( ):
		if ("nope" == commit_msg_container_dic_for_common_type[ dic_key ]):
			print ( "key:" + dic_key + ", can not found in file: + " + file_path )
			return False

	return True


def bugfix_format_check( file_path ):
	pos_index_list = [ ]
	global current_commit_type
	print ( "---> bugfix_format_check" )
	ret_val = got_not_must_check_info ( file_path )
	if False == ret_val:
		return False

	with open ( file_path, "rt", encoding = "UTF-8" ) as fp:
		for line_index, data in enumerate ( fp, start = 1 ):

			data.strip ( )
			value_start_position = data.find ( VALUE_CUT_MARK )
			report_info_mark = data[ 0: value_start_position ]

			report_info_mark_value = data[ (value_start_position + 1): ]
			# remove left and right space
			# check report type start, first check
			# check which report type it is
			# ATTENTION: force check "Bug Fix" on file first line
			# for type_dic_value in commit_msg_container_dic_for_bug_fix.values() :
			if (report_info_mark == current_commit_type):
				commit_msg_container_dic_for_bug_fix[ report_info_mark ] = report_info_mark_value
				store_info_to_param ( report_info_mark, report_info_mark_value, False )
				continue

			else:
				"""store every key line position to dic"""
				for x_key in commit_msg_container_dic_for_bug_fix.keys ( ):
					"""find if items in defined dic, these are multi-line info"""
					if x_key == report_info_mark:
						commit_msg_container_dic_for_bug_fix[ report_info_mark ] = str ( line_index )
						pos_index_list.append ( line_index )

	shell_print_start_line = ""
	shell_print_stop_line = ""

	tmp_file_path = cur_work_abs_path + "/tmp.txt"

	for index in range ( 0, len ( pos_index_list ) ):
		shell_print_start_line = str ( pos_index_list[ index ] + 1 )

		if index == len ( pos_index_list ) - 1:
			"""reach file end"""
			shell_print_stop_line = "50"
		else:
			shell_print_stop_line = str ( pos_index_list[ index + 1 ] - 1 )

		tmp_shell_cmd = "sed -ne '" + shell_print_start_line + "," + shell_print_stop_line + " p' " + commit_file_path + " > " + tmp_file_path

		do_shell_cmd ( tmp_shell_cmd )

		for dic_key, dic_value in commit_msg_container_dic_for_bug_fix.items ( ):
			try:
				(int ( dic_value ))
			except (ValueError):
				# print("detect report mark key index 1")
				continue

			if ((int ( dic_value ) + 1) <= int ( shell_print_stop_line )) and (
					(int ( dic_value ) + 1) >= int ( shell_print_start_line )):
				"""clean"""
				commit_msg_container_dic_for_bug_fix[ dic_key ] = "\n"
				with open ( tmp_file_path, "rt", encoding = "UTF-8" ) as tmp_fp:
					for line_index, data in enumerate ( tmp_fp, start = 1 ):
						linecache.clearcache ( )
						commit_msg_container_dic_for_bug_fix[ dic_key ] += linecache.getline ( tmp_file_path,
								line_index )

	# check all message have got
	for dic_key, dic_value in commit_msg_container_dic_for_bug_fix.items ( ):
		if (len ( dic_value ) < MINI_INFO_LEN):
			print ( dic_key + "value is empty " + ", value: " + dic_value )
			return False
		if (dic_value.find ( template_msg_mark ) > 0):
			print ( "------------------------------------------------------------------------------" )
			print ( "some nessage message didn't write, please re-check commit message. " + dic_value )
			print ( "------------------------------------------------------------------------------" )
			return False

	# store msg
	for dic_key, dic_value in commit_msg_container_dic_for_common_type.items ( ):
		if dic_value.lower ( ) in skip_commit_mark_list:
			print ( "skip: " + dic_key + "information" )
			continue
		store_info_to_param ( dic_key, dic_value, False )

	for dic_key, dic_value in commit_msg_container_dic_for_bug_fix.items ( ):
		if (dic_key == current_commit_type):
			continue
		if (dic_key == "Associated Branch Path"):
			if dic_value.lower ( ) in skip_commit_mark_list:
				continue
		else:
			store_info_to_param ( dic_key, dic_value, True )
	tmp_shell_cmd = "rm -f " + tmp_file_path
	do_shell_cmd ( tmp_shell_cmd )

	return (do_commit ( cmit_msg ))


def new_feature_format_check( file_path ):
	pos_index_list = [ ]
	global current_commit_type
	print ( "---> new_feature_format_check" )
	ret_val = got_not_must_check_info ( file_path )
	if False == ret_val:
		return False

	with open ( file_path, "rt", encoding = "UTF-8" ) as fp:
		for line_index, data in enumerate ( fp, start = 1 ):

			data.strip ( )
			value_start_position = data.find ( VALUE_CUT_MARK )
			report_info_mark = data[ 0: value_start_position ]

			report_info_mark_value = data[ (value_start_position + 1): ]
			# remove left and right space
			# check report type start, first check
			# check which report type it is
			# ATTENTION: force check "Bug Fix" on file first line
			# TODO: find way to remove commit_type_dic["X"]
			if (report_info_mark == current_commit_type):
				commit_msg_container_dic_for_new_feature[ report_info_mark ] = report_info_mark_value
				store_info_to_param ( report_info_mark, report_info_mark_value, False )
				continue

			else:
				"""store every key line position to dic"""
				for x_key in commit_msg_container_dic_for_new_feature.keys ( ):
					"""find if items in defined dic, these are multi-line info"""

					if x_key == report_info_mark:
						commit_msg_container_dic_for_new_feature[ report_info_mark ] = str ( line_index )
						pos_index_list.append ( line_index )

	shell_print_start_line = ""
	shell_print_stop_line = ""

	tmp_file_path = cur_work_abs_path + "/tmp.txt"

	for index in range ( 0, len ( pos_index_list ) ):
		shell_print_start_line = str ( pos_index_list[ index ] + 1 )
		if index == len ( pos_index_list ) - 1:
			"""reach file end"""
			shell_print_stop_line = "50"
		else:
			shell_print_stop_line = str ( pos_index_list[ index + 1 ] - 1 )

		tmp_shell_cmd = "sed -ne '" + shell_print_start_line + "," + shell_print_stop_line + " p' " + commit_file_path + " > " + tmp_file_path
		do_shell_cmd ( tmp_shell_cmd )

		for dic_key, dic_value in commit_msg_container_dic_for_new_feature.items ( ):
			try:
				(int ( dic_value ))
			except (ValueError):
				continue

			if ((int ( dic_value ) + 1) <= int ( shell_print_stop_line )) and (
					(int ( dic_value ) + 1) >= int ( shell_print_start_line )):
				"""clean"""
				commit_msg_container_dic_for_new_feature[ dic_key ] = "\n"
				with open ( tmp_file_path, "rt", encoding = "UTF-8" ) as tmp_fp:
					for line_index, data in enumerate ( tmp_fp, start = 1 ):
						linecache.clearcache ( )
						commit_msg_container_dic_for_new_feature[ dic_key ] += linecache.getline ( tmp_file_path,
								line_index )

	# check all message have got
	for dic_key, dic_value in commit_msg_container_dic_for_new_feature.items ( ):
		if (len ( dic_value ) < MINI_INFO_LEN):
			print ( dic_key + "value is empty " + ", value: " + dic_value )
			return False
		if (dic_value.find ( template_msg_mark ) > 0):
			print ( "------------------------------------------------------------------------------" )
			print ( "some message didn't write, please re-check commit message. " + dic_value )
			print ( "------------------------------------------------------------------------------" )
			return False
	# store msg
	for dic_key, dic_value in commit_msg_container_dic_for_common_type.items ( ):
		if dic_value.lower ( ) in skip_commit_mark_list:
			print ( "skip: " + dic_key + "information" )
			continue
		store_info_to_param ( dic_key, dic_value, False )

	for dic_key, dic_value in commit_msg_container_dic_for_new_feature.items ( ):
		if (dic_key == current_commit_type):
			continue
		if (dic_key == "Associated Branch Path"):
			if dic_value.lower ( ) in skip_commit_mark_list:
				continue
		else:
			store_info_to_param ( dic_key, dic_value, True )

	tmp_shell_cmd = "rm -f " + tmp_file_path
	do_shell_cmd ( tmp_shell_cmd )

	return (do_commit ( cmit_msg ))


def feature_upgrade_format_check( file_path ):
	pos_index_list = [ ]
	global current_commit_type
	print ( "---> feature_upgrade_format_check" )
	ret_val = got_not_must_check_info ( file_path )
	if False == ret_val:
		return False

	with open ( file_path, "rt", encoding = "UTF-8" ) as fp:
		for line_index, data in enumerate ( fp, start = 1 ):

			data.strip ( )
			value_start_position = data.find ( VALUE_CUT_MARK )
			report_info_mark = data[ 0: value_start_position ]
			report_info_mark_value = data[ (value_start_position + 1): ]
			# remove left and right space
			# check report type start, first check
			# check which report type it is
			# ATTENTION: force check "Bug Fix" on file first line
			# TODO: find way to remove commit_type_dic["X"]
			if (report_info_mark == current_commit_type):
				commit_msg_container_dic_for_feature_upgrade[ report_info_mark ] = report_info_mark_value
				store_info_to_param ( report_info_mark, report_info_mark_value, False )
				continue

			else:
				"""store every key line position to dic"""
				for x_key in commit_msg_container_dic_for_feature_upgrade.keys ( ):
					"""find if items in defined dic, these are multi-line info"""

					if x_key == report_info_mark:
						commit_msg_container_dic_for_feature_upgrade[ report_info_mark ] = str ( line_index )
						pos_index_list.append ( line_index )

	shell_print_start_line = ""
	shell_print_stop_line = ""

	tmp_file_path = cur_work_abs_path + "/tmp.txt"

	for index in range ( 0, len ( pos_index_list ) ):
		shell_print_start_line = str ( pos_index_list[ index ] + 1 )
		if index == len ( pos_index_list ) - 1:
			"""reach file end"""
			shell_print_stop_line = "50"
		else:
			shell_print_stop_line = str ( pos_index_list[ index + 1 ] - 1 )

		tmp_shell_cmd = "sed -ne '" + shell_print_start_line + "," + shell_print_stop_line + " p' " + commit_file_path + " > " + tmp_file_path
		do_shell_cmd ( tmp_shell_cmd )

		for dic_key, dic_value in commit_msg_container_dic_for_feature_upgrade.items ( ):
			try:
				(int ( dic_value ))
			except (ValueError):
				continue

			if ((int ( dic_value ) + 1) <= int ( shell_print_stop_line )) and (
					(int ( dic_value ) + 1) >= int ( shell_print_start_line )):
				"""clean"""
				commit_msg_container_dic_for_feature_upgrade[ dic_key ] = "\n"
				with open ( tmp_file_path, "rt", encoding = "UTF-8" ) as tmp_fp:
					for line_index, data in enumerate ( tmp_fp, start = 1 ):
						linecache.clearcache ( )
						commit_msg_container_dic_for_feature_upgrade[ dic_key ] += linecache.getline ( tmp_file_path,
								line_index )

	# check all message have got
	for dic_key, dic_value in commit_msg_container_dic_for_feature_upgrade.items ( ):
		if (len ( dic_value ) < MINI_INFO_LEN):
			print ( dic_key + "value is empty " + ", value: " + dic_value )
			return False
		if (dic_value.find ( template_msg_mark ) > 0):
			print ( "------------------------------------------------------------------------------" )
			print ( "some message didn't write, please re-check commit message. " + dic_value )
			print ( "------------------------------------------------------------------------------" )
			return False
	# store msg
	for dic_key, dic_value in commit_msg_container_dic_for_common_type.items ( ):
		if dic_value.lower ( ) in skip_commit_mark_list:
			print ( "skip: " + dic_key + "information" )
			continue
		store_info_to_param ( dic_key, dic_value, False )

	for dic_key, dic_value in commit_msg_container_dic_for_feature_upgrade.items ( ):
		if (dic_key == current_commit_type):
			continue
		if (dic_key == "Associated Branch Path"):
			if dic_value.lower ( ) in skip_commit_mark_list:
				continue
		else:
			store_info_to_param ( dic_key, dic_value, True )

	tmp_shell_cmd = "rm -f " + tmp_file_path
	do_shell_cmd ( tmp_shell_cmd )

	return (do_commit ( cmit_msg ))


def revert_format_check( file_path ):
	pos_index_list = [ ]
	global current_commit_type
	print ( "---> revert_format_check" )
	ret_val = got_not_must_check_info ( file_path )
	if False == ret_val:
		return False

	with open ( file_path, "rt", encoding = "UTF-8" ) as fp:
		for line_index, data in enumerate ( fp, start = 1 ):

			data.strip ( )
			value_start_position = data.find ( VALUE_CUT_MARK )
			report_info_mark = data[ 0: value_start_position ]

			report_info_mark_value = data[ (value_start_position + 1): ]
			# remove left and right space
			# check report type start, first check
			# check which report type it is
			# ATTENTION: force check "Bug Fix" on file first line
			# TODO: find way to remove commit_type_dic["X"]
			if (report_info_mark == current_commit_type):
				commit_msg_container_dic_for_revert[ report_info_mark ] = report_info_mark_value
				store_info_to_param ( report_info_mark, report_info_mark_value, False )
				continue

			else:
				"""store every key line position to dic"""
				for x_key in commit_msg_container_dic_for_revert.keys ( ):
					"""find if items in defined dic, these are multi-line info"""

					if x_key == report_info_mark:
						commit_msg_container_dic_for_revert[ report_info_mark ] = str ( line_index )
						pos_index_list.append ( line_index )

	shell_print_start_line = ""
	shell_print_stop_line = ""

	tmp_file_path = cur_work_abs_path + "/tmp.txt"

	for index in range ( 0, len ( pos_index_list ) ):
		shell_print_start_line = str ( pos_index_list[ index ] + 1 )
		if index == len ( pos_index_list ) - 1:
			"""reach file end"""
			shell_print_stop_line = "50"
		else:
			shell_print_stop_line = str ( pos_index_list[ index + 1 ] - 1 )

		tmp_shell_cmd = "sed -ne '" + shell_print_start_line + "," + shell_print_stop_line + " p' " + commit_file_path + " > " + tmp_file_path
		do_shell_cmd ( tmp_shell_cmd )

		for dic_key, dic_value in commit_msg_container_dic_for_revert.items ( ):
			try:
				(int ( dic_value ))
			except (ValueError):
				continue

			if ((int ( dic_value ) + 1) <= int ( shell_print_stop_line )) and (
					(int ( dic_value ) + 1) >= int ( shell_print_start_line )):
				"""clean"""
				commit_msg_container_dic_for_revert[ dic_key ] = "\n"
				with open ( tmp_file_path, "rt", encoding = "UTF-8" ) as tmp_fp:
					for line_index, data in enumerate ( tmp_fp, start = 1 ):
						linecache.clearcache ( )
						commit_msg_container_dic_for_revert[ dic_key ] += linecache.getline ( tmp_file_path,
								line_index )

	# check all message have got
	for dic_key, dic_value in commit_msg_container_dic_for_revert.items ( ):
		if (len ( dic_value ) < MINI_INFO_LEN):
			print ( dic_key + "value is empty " + ", value: " + dic_value )
			return False
		if (dic_value.find ( template_msg_mark ) > 0):
			print ( "------------------------------------------------------------------------------" )
			print ( "some message didn't write, please re-check commit message. " + dic_value )
			print ( "------------------------------------------------------------------------------" )
			return False
	# store msg
	for dic_key, dic_value in commit_msg_container_dic_for_common_type.items ( ):
		if dic_value.lower ( ) in skip_commit_mark_list:
			print ( "skip: " + dic_key + "information" )
			continue
		store_info_to_param ( dic_key, dic_value, False )

	for dic_key, dic_value in commit_msg_container_dic_for_revert.items ( ):
		if (dic_key == current_commit_type):
			continue
		if (dic_key == "Associated Branch Path"):
			if dic_value.lower ( ) in skip_commit_mark_list:
				continue
		else:
			store_info_to_param ( dic_key, dic_value, True )

	tmp_shell_cmd = "rm -f " + tmp_file_path
	do_shell_cmd ( tmp_shell_cmd )

	return (do_commit ( cmit_msg ))


def merge_format_check( file_path ):
	pos_index_list = [ ]
	global current_commit_type
	print ( "---> merge_format_check" )
	ret_val = got_not_must_check_info ( file_path )
	if False == ret_val:
		return False

	with open ( file_path, "rt", encoding = "UTF-8" ) as fp:
		for line_index, data in enumerate ( fp, start = 1 ):

			data.strip ( )
			value_start_position = data.find ( VALUE_CUT_MARK )
			report_info_mark = data[ 0: value_start_position ]
			report_info_mark_value = data[ (value_start_position + 1): ]
			# remove left and right space
			# check report type start, first check
			# check which report type it is
			# ATTENTION: force check "Bug Fix" on file first line
			# TODO: find way to remove commit_type_dic["X"]
			if (report_info_mark == current_commit_type):
				commit_msg_container_dic_for_merge[ report_info_mark ] = report_info_mark_value
				store_info_to_param ( report_info_mark, report_info_mark_value, False )
				continue

			else:
				"""store every key line position to dic"""
				for x_key in commit_msg_container_dic_for_merge.keys ( ):
					"""find if items in defined dic, these are multi-line info"""

					if x_key == report_info_mark:
						commit_msg_container_dic_for_merge[ report_info_mark ] = str ( line_index )
						pos_index_list.append ( line_index )

	shell_print_start_line = ""
	shell_print_stop_line = ""

	tmp_file_path = cur_work_abs_path + "/tmp.txt"

	for index in range ( 0, len ( pos_index_list ) ):
		shell_print_start_line = str ( pos_index_list[ index ] + 1 )
		if index == len ( pos_index_list ) - 1:
			"""reach file end"""
			shell_print_stop_line = "50"
		else:
			shell_print_stop_line = str ( pos_index_list[ index + 1 ] - 1 )

		tmp_shell_cmd = "sed -ne '" + shell_print_start_line + "," + shell_print_stop_line + " p' " + commit_file_path + " > " + tmp_file_path
		do_shell_cmd ( tmp_shell_cmd )

		for dic_key, dic_value in commit_msg_container_dic_for_merge.items ( ):
			try:
				(int ( dic_value ))
			except (ValueError):
				continue

			if ((int ( dic_value ) + 1) <= int ( shell_print_stop_line )) and (
					(int ( dic_value ) + 1) >= int ( shell_print_start_line )):
				"""clean"""
				commit_msg_container_dic_for_merge[ dic_key ] = "\n"
				with open ( tmp_file_path, "rt", encoding = "UTF-8" ) as tmp_fp:
					for line_index, data in enumerate ( tmp_fp, start = 1 ):
						linecache.clearcache ( )
						commit_msg_container_dic_for_merge[ dic_key ] += linecache.getline ( tmp_file_path, line_index )

	# check all message have got
	for dic_key, dic_value in commit_msg_container_dic_for_merge.items ( ):
		if (len ( dic_value ) < MINI_INFO_LEN):
			print ( dic_key + "value is empty " + ", value: " + dic_value )
			return False
		if (dic_value.find ( template_msg_mark ) > 0):
			print ( "------------------------------------------------------------------------------" )
			print ( "some message didn't write, please re-check commit message. " + dic_value )
			print ( "------------------------------------------------------------------------------" )
			return False
	# store msg
	for dic_key, dic_value in commit_msg_container_dic_for_common_type.items ( ):
		if dic_value.lower ( ) in skip_commit_mark_list:
			print ( "skip: " + dic_key + "information" )
			continue
		store_info_to_param ( dic_key, dic_value, False )

	for dic_key, dic_value in commit_msg_container_dic_for_merge.items ( ):
		if (dic_key == current_commit_type):
			continue
		if (dic_key == "Associated Branch Path"):
			if dic_value.lower ( ) in skip_commit_mark_list:
				continue
		else:
			store_info_to_param ( dic_key, dic_value, True )

	tmp_shell_cmd = "rm -f " + tmp_file_path
	do_shell_cmd ( tmp_shell_cmd )

	return (do_commit ( cmit_msg ))


def format_check_commit( file_path ):
	report_mark = ""
	global current_commit_type
	if (False == is_file_exist ( file_path )):
		return False

	# format_commit_file(file_path) # already formatted

	with open ( file_path, "rt", encoding = "UTF-8" ) as fp:
		# find head mark
		for data in fp:
			data.strip ( )
			value_start_position = data.find ( VALUE_CUT_MARK )
			report_mark = data[ 0: value_start_position ]
			break
	# print("---> report_mark: " + report_mark + " position: " + str(value_start_position))
	# check if head mark dic
	for key, value in commit_type_dic.items ( ):
		global current_commit_type
		if value == report_mark:
			# print ("---> key: " + key + ", value: " + value)
			if "1" == key:

				current_commit_type = "Bug Fix"
				ret_val = bugfix_format_check ( file_path )
				if (False == ret_val):
					print ( "error: format: " + file_path )
					return False
			elif "2" == key:
				current_commit_type = "New Feature"
				ret_val = new_feature_format_check ( file_path )
				if (False == ret_val):
					print ( "error: format: " + file_path )
					return False
			elif "3" == key:
				current_commit_type = "Feature Upgrade"
				ret_val = feature_upgrade_format_check ( file_path )
				if (False == ret_val):
					print ( "error: format: " + file_path )
					return False
			elif "4" == key:
				current_commit_type = "Revert"
				ret_val = revert_format_check ( file_path )
				if (False == ret_val):
					print ( "error: format: " + file_path )
					return False
			elif "5" == key:
				current_commit_type = "Merge"
				ret_val = merge_format_check ( file_path )
				if (False == ret_val):
					print ( "error: format: " + file_path )
					return False
			else:
				print ( "out of support list range" )
				return False

	return True


def get_and_create_match_template( search_str ):
	found_head = False
	found_tail = False
	start_line = 0
	end_line = 1
	line_index = 1

	# print ("transfered in str: " + search_str)
	if is_file_exist ( template_file_path ):
		print ( "start find str: " + search_str )
		with open ( template_file_path, "rt", encoding = "UTF-8" ) as fp:
			for line_index, data in enumerate ( fp, start = 1 ):
				# print("line_index = " + str(line_index))
				if (False == found_head) and (search_str in data):
					print ( "found in line: " + str ( line_index ) )
					start_line = line_index
					found_head = True

				if (found_head) and (DIVID_MARK in data):
					print ( "found in line: " + str ( line_index ) )
					found_tail = True
					end_line = line_index

					tmp_shell_cmd = "rm -vf " + commit_file_path
					do_shell_cmd ( tmp_shell_cmd )

				if found_head and found_tail:
					if not os.path.exists ( commit_file_path ):
						tmp_shell_cmd = "touch " + commit_file_path
						print ( "shell: " + tmp_shell_cmd )
						do_shell_cmd ( tmp_shell_cmd )
					else:
						print ( "file: " + commit_file_path + "exist" )
					break

			if (False == found_head) or (False == found_tail):
				print ( "str: " + search_str + " not found" )

		loop_index = start_line
		with open ( commit_file_path, "wt", encoding = "UTF-8" ) as commit_fp:
			print (
					"============================== TEMPLATE ==============================" )
			for loop_index in range ( start_line, end_line ):
				# print("loop_index = " + str(loop_index))
				linecache.clearcache ( )
				temp_data = linecache.getline ( template_file_path, loop_index )
				print ( temp_data.strip ( ) )  # print cut line end '\n'
				commit_fp.write ( temp_data )

			print ( "=====================================================================" )
			print ( "commit template created and store in: " + commit_file_path )
			return True
	else:
		print ( "commit template file missing..." )
		return False


# program run start here
print ( "CUR_PATH: " )
print ( "\t ---> " + cur_work_abs_path )

# usr_val = do_shell_cmd("ls -all")
# if (-1 != usr_val):
#     print(usr_val)

print ( "Software Version: " + VERSION + " Date: " + UPGRADE_DATE )

loop_time = 0
commit_template_created_flag = False
commit_check_finished_flag = False
ret_value = False

ret_value = find_repo_path_create_commit_file_path ( )
if False == ret_value:
	print ( "cannot find repo path, please check" )
	exit ( 0 )

while (False == commit_check_finished_flag) and (loop_time < 3):
	loop_time += 1
	# created commit file
	if commit_template_created_flag:
		retry_ticks = 0
		while (retry_ticks < 3):
			retry_ticks += 1
			input_value = input (
					"Template created. waitting for commit, input y to continue commit. input n for exit " )
			if (input_value == 'Y') or (input_value == 'y'):
				break
			elif (input_value == 'N') or (input_value == 'n'):
				print ( "exit program" )
				exit ( 0 )
			else:
				print ( "input error, retry" )
				continue
	# has commit file when program run
	if is_file_exist ( commit_file_path ):
		format_commit_file ( commit_file_path )
		print ( "\nCurrent commit msg:\n" )
		read_and_print_file ( commit_file_path )
		print ( "Do you need current commit file message to commit" )
		user_input = input ( "Enter y or n, for help input help: " )

		if (user_input.lower ( ) == "help"):
			print ( help_info_container_dic[ "help" ] )
			exit ( 1 )
		elif (user_input == 'Y') or (user_input == 'y'):
			print ( "do_format_check_and_commit" )
			ret_val = format_check_commit ( commit_file_path )
			if ret_val:
				commit_check_finished_flag = True
				break
			else:
				commit_check_finished_flag = True
				print (
						"----------------------- fomat check failed -----------------------" )
				break
		elif (user_input == 'N') or (user_input == 'n'):
			tmp_shell_cmd = "rm -vf " + commit_file_path
			do_shell_cmd ( tmp_shell_cmd )
			commit_template_created_flag = False
		else:
			continue
	else:
		loop_ticks = 0
		while loop_ticks < 3:
			loop_ticks += 1
			print ( "support commit type:" )
			for key, value in commit_type_dic.items ( ):
				print ( key + ". " + value )
			print ( "===================================================" )
			input_value = input ( "please choose the type, integer: " )

			try:
				input_num = int ( input_value )
				# check input integer is in range map
				map_len = list ( commit_type_dic )
				# print("map_len:" + str(len(map_len)))

				if (input_num <= len ( map_len )):
					print ( "you have choosed: " + commit_type_dic[ input_value ] )
					ret_value = get_and_create_match_template ( commit_type_dic[ input_value ] )
					if ret_value:
						commit_template_created_flag = True
						break
					loop_ticks = 0
				else:
					print ( "input numberr out of range 1 ~ " + str ( len ( map_len ) ) )
					continue
				break
			except:
				print ( "input error" )
		if commit_template_created_flag:
			continue
		# pass
		if loop_ticks == 3:
			print ( "too much input errors, exit." )
			exit ( -1 )

# if __name__ == '__main__':

# ------------------------------------------- END LINE -------------------------------------------#
