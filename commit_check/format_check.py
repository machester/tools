# -*- coding: utf-8 -*-
############################################# Description #############################################
#
#
#######################################################################################################

import os
import subprocess
import linecache

VERSION = "1.0"

# template_file_path = "/mnt/d/code/github/tools/commit_check/commit_format_template.txt"
# commit_file_path = "/mnt/d/code/github/tools/commit_check/python_commit.txt"

cur_work_abs_path = os.path.abspath('.')

# for test
template_file_path = cur_work_abs_path + "/commit_format_template.txt"
commit_file_path = cur_work_abs_path + "/python_commit.txt"

DIVID_MARK = "======"
VALUE_CUT_MARK = ":"

MINI_INFO_LEN = 3

COMMENT = "please choose the type: 1. Bug Fix 2. New Feature 3.Feature Upgrade 4.Revert 5.Merge"

commit_type_dic = {"1": "Bug Fix",
                   "2": "New Feature",
                   "3": "Feature Upgrade",
                   "4": "Revert",
                   "5": "Merge"
                   }

# commit_msg_container_dic = {
#     "Bug Fix"               : "nope",
#     "New Feature"           : "nope",
#     "Feature Upgrade"       : "nope",
#     "Revert"                : "nope",
#     "Merge"                 : "nope",

#     "Zen Tao"               : "nope",
#     "MTK CR"                : "nope",
#     "UNISOC CQ"             : "nope",

#     "Detail Descriptions"   : "nope",
#     "Why"                   : "nope",
#     "How"                   : "nope",
#     "Associated branch path": "nope",
#     "What"                  : "nope",
#     "Options"               : "nope",
#     "Affected submission Id" : "nope"
# }

help_info_container_dic = {
    "help":   "\
-------------------------------------------- HELP ----------------------------------------------\n\
------------------------------------------------------------------------------------------------",
    "notic":   "\
-------------------------------------------- NOTICE --------------------------------------------\n\
------------------------------------------------------------------------------------------------"
}

commit_msg_container_dic_for_common_type = {
    "Zen Tao": "nope",
    "MTK CR": "nope",
    "UNISOC CQ": "nope",
    "Associated branch path": "nope",
}

commit_msg_container_dic_for_bug_fix = {
    "Bug Fix": "nope",
    "Detail Descriptions": "nope",
    "Why": "nope",
    "How": "nope",
    "Affected submission Id": "nope"
}

commit_msg_container_dic_for_new_feature = {
    "New Feature": "nope",
    "Detail Descriptions": "nope",
    "What": "nope",
    "Options": "nope",
    "Affected submission Id": "nope"
}

commit_msg_container_dic_for_feature_upgrade = {
    "Feature Upgrade": "nope",
    "Detail Descriptions": "nope",
    "What": "nope",
    "Why": "nope",
    "How": "nope",
    "Options": "nope",
    "Affected submission Id": "nope"
}

commit_msg_container_dic_for_revert = {
    "Revert": "nope",
    "Detail Descriptions": "nope",
    "Why": "nope",
    "How": "nope",
    "Affected submission Id": "nope"
}

commit_msg_container_dic_for_merge = {
    "Merge": "nope",
    "Detail Descriptions": "nope",
    "What": "nope",
    "Why": "nope",
    "How": "nope",
    "Options": "nope",
    "Affected submission Id": "nope"
}


# commit_multiline_info_list = ["Detail Descriptions" , "Why", "How", "Associated branch path" , "What", "Options", "Affected submission Id"]

# commit_must_check_list = ["Bug Fix", "New Feature", "Feature Upgrade", "Revert", "Merge", "Detail Descriptions", "Why", "How"]


def do_shell_cmd(shell_cmd):
    try:
        res = subprocess.Popen(shell_cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
        lines = res.stdout.read()  # read cmd ouput
        lines.decode('utf-8')  # decode
        res.wait()  # wait cmd
        res.stdout.close()  # close std out
        return lines
    except BaseException as e:
        print("error: shell cmd: " + shell_cmd)
        return (-1)


def is_file_exist(path_name):
    try:
        # print("ready to check path: < " + path_name + " > if exist")
        if not (os.path.exists(path_name)):
            print("not exist")
            return False
        else:
            print("exist")
            return True
    except FileNotFoundError:
        print("error: path name or format")
        return LookupError


def read_and_print_file(path_name):
    with open(path_name, "rt", encoding="UTF-8") as fp:
        print("============================== INFORMATION ==============================")
        for line_data in fp:
            print(line_data.strip())  # readline and delete last '\n'
        print("=========================================================================")


def do_commit(file_path):
    commit_msg = ""

    with open(file_path, "rt", encoding="UTF-8") as fp:
        for data in fp:
            data.strip()
            commit_msg += data

    tmp_shell_cmd = "git commit -sm\n" + commit_msg
    ret_val = do_shell_cmd(tmp_shell_cmd)
    if (-1 != ret_val):
        return True
    else:
        return False


def format_commit_file(file_path):
    # format commit.txt file
    # delete space
    tmp_shell_cmd = "sed -i 's/^[[:space:]]*//' " + commit_file_path
    ret_val = do_shell_cmd(tmp_shell_cmd)
    if (-1 == ret_val):
        return False
    # delete head empyty line
    tmp_shell_cmd = "sed -i '/^$/d' " + commit_file_path
    ret_val = do_shell_cmd(tmp_shell_cmd)
    if (-1 == ret_val):
        return False
    return True

# return a string list, start with line next is value without start_mark
# tmp_list["start_mark_position", "after_start_mark_value"]
# tag and information on same line


def got_not_must_check_info(file_path):
    tmp_list = ["nope", "empty"]
    found_value_flag = False

    with open(file_path, "rt", encoding="UTF-8") as fp:
        for line_index, data in enumerate(fp, start=1):
            data.strip()
            value_start_position = data.find(VALUE_CUT_MARK)
            report_info_mark = data[0: value_start_position]
            report_info_mark_value = data[(value_start_position + 1):]
            # remove left and right space
            report_info_mark_value = report_info_mark_value.strip()
            # print ("report_info_mark len:" + str(len(report_info_mark)) + " value:"
            #         + report_info_mark + "; " +  "report_info_mark_value len: "
            #         + str (len (report_info_mark_value)) + " , value: " + report_info_mark_value)

            # store value
            for report_info_mark in commit_msg_container_dic_for_common_type.keys():
                commit_msg_container_dic_for_common_type[report_info_mark] = report_info_mark_value

        # check if all items got data
    for dic_value in commit_msg_container_dic_for_common_type.keys():
        if ("nope" == dic_value):
            print("key:" + dic_key + "can not found in file: + " + file_path)
            return False

    return True


# TODO:

multi_line_info_list = [""]


def bugfix_format_check(file_path):
    info_start_line = -1
    info_stop_line = -1
    items_head_found = False
    items_info_tail_found = False
    reach_file_end = False
    current_info_head = ""

    print("---> bugfix_format_check")
    ret_val = got_not_must_check_info(file_path)
    if False == ret_val:
        return False

    with open(file_path, "rt", encoding="UTF-8") as fp:
        for line_index, data in enumerate(fp, start=1):

            data.strip()
            value_start_position = data.find(VALUE_CUT_MARK)
            report_info_mark = data[0: value_start_position]
            report_info_mark_value = data[(value_start_position + 1):]
            # remove left and right space
            report_info_mark_value = report_info_mark_value.strip()
            # print("report_info_mark len:" + str(len(report_info_mark)) + " value:"
            #       + report_info_mark + "; " + "report_info_mark_value len: "
            #       + str(len(report_info_mark_value)) + " , value: " + report_info_mark_value)
            # print("----------------------------------------------------------------------------------")
            # check report type start, first check
            # check which report type it is
            # ATTENTION: force check "Bug Fix" on file first line
            if (report_info_mark == commit_type_dic["1"]):
                print("store key: " + report_info_mark +" ; value: " + report_info_mark_value)
                commit_msg_container_dic_for_bug_fix[report_info_mark] = report_info_mark_value
               
            else:
                for x_key in commit_msg_container_dic_for_bug_fix.keys():
                    """find if items in defined dic, these are multi-line info"""
                    if x_key == report_info_mark:
                        info_start_line = line_index    # items start
                        print(report_info_mark + " : start line: " + str(line_index))
                        items_head_found = True
                        current_info_head = report_info_mark
                        break
                    elif(items_head_found) and (False == items_info_tail_found) and (VALUE_CUT_MARK in data):
                        """start to found target items info tail"""
                        print("stop line: " + str(line_index))
                        info_stop_line = line_index
                        items_info_tail_found = True
                
            # store info messagge
            if items_head_found and (False == items_info_tail_found):
                print("----------------------- multi_line_info_list S ------------------------------")
                multi_line_info_list.append(data.strip())
                for x in multi_line_info_list:
                    print(x)
                print("-------------------------multi_line_info_list E ----------------------------")

            # move the start and stop line to point to info
            if (False == items_info_tail_found) or (info_start_line < info_stop_line):
                print("error: can not found: " + report_info_mark + " info")
                # return False
            elif (items_info_tail_found) and (reach_file_end):
                items_info_tail_found = False
                for x in multi_line_info_list:
                    commit_msg_container_dic_for_bug_fix[current_info_head] += multi_line_info_list[x]
                report_info_mark = "nope"

        print("============================ S ========================================")
        for dic_key, dic_value in commit_msg_container_dic_for_bug_fix.items():
            print(dic_key + " : " + dic_value)
        print("============================= E ========================================")
    return True


def new_feature_format_check(file_path):
    print("---> new_feature_format_check")
    ret_val = got_not_must_check_info(file_path)
    if False == ret_val:
        return False

    return True


def feature_upgrade_format_check(file_path):
    print("---> feature_upgrade_format_check")
    ret_val = got_not_must_check_info(file_path)
    if False == ret_val:
        return False

    return True


def revert_format_check(file_path):
    print("---> revert_format_check")
    ret_val = got_not_must_check_info(file_path)
    if False == ret_val:
        return False

    return True


def merge_format_check(file_path):
    print("---> merge_format_check")
    ret_val = got_not_must_check_info(file_path)
    if False == ret_val:
        return False

    return True


# TODO:

def format_check_commit(file_path):
    report_mark = ""

    if (False == is_file_exist(file_path)):
        return False

    # format_commit_file(file_path) # already formatted

    with open(file_path, "rt", encoding="UTF-8") as fp:
        # find head mark
        for data in fp:
            data.strip()
            value_start_position = data.find(VALUE_CUT_MARK)
            report_mark = data[0: value_start_position]
            break
        # print("---> report_mark: " + report_mark + " position: " + str(value_start_position))
        # check if head mark dic
    for key, value in commit_type_dic.items():
        if value == report_mark:
            # print ("---> key: " + key + ", value: " + value)
            if "1" == key:
                ret_val = bugfix_format_check(file_path)
                if (False == ret_val):
                    print("error: format: " + file_path)
                    return False
            elif "2" == key:
                ret_val = new_feature_format_check(file_path)
                if (False == ret_val):
                    print("error: format: " + file_path)
                    return False
            elif "3" == key:
                ret_val = feature_upgrade_format_check(file_path)
                if (False == ret_val):
                    print("error: format: " + file_path)
                    return False
            elif "4" == key:
                ret_val = revert_format_check(file_path)
                if (False == ret_val):
                    print("error: format: " + file_path)
                    return False
            elif "5" == key:
                ret_val = merge_format_check(file_path)
                if (False == ret_val):
                    print("error: format: " + file_path)
                    return False
            else:
                print("out of support list range")
                return False

    return True


def get_and_create_match_template(search_str):
    found_head = False
    found_tail = False
    start_line = 0
    end_line = 1
    line_index = 1

    # print ("transfered in str: " + search_str)
    if is_file_exist(template_file_path):
        print("start find str: " + search_str)
        with open(template_file_path, "rt", encoding="UTF-8") as fp:
            for line_index, data in enumerate(fp, start=1):
                # print("line_index = " + str(line_index))
                if (False == found_head) and (search_str in data):
                    print("found in line: " + str(line_index))
                    start_line = line_index
                    found_head = True

                if (found_head) and (DIVID_MARK in data):
                    print("found in line: " + str(line_index))
                    found_tail = True
                    end_line = line_index

                    tmp_shell_cmd = "rm -vf " + commit_file_path
                    do_shell_cmd(tmp_shell_cmd)

                if found_head and found_tail:
                    if not os.path.exists(commit_file_path):
                        tmp_shell_cmd = "touch " + commit_file_path
                        print("shell: " + tmp_shell_cmd)
                        do_shell_cmd(tmp_shell_cmd)
                    else:
                        print("file: " + commit_file_path + "exist")
                    break

            if (False == found_head) or (False == found_tail):
                print("str: " + search_str + " not found")

        loop_index = start_line
        with open(commit_file_path, "wt", encoding="UTF-8") as commit_fp:
            print(
                "============================== TEMPLATE ==============================")
            for loop_index in range(start_line, end_line):
                # print("loop_index = " + str(loop_index))
                linecache.clearcache()
                temp_data = linecache.getline(template_file_path, loop_index)
                print(temp_data.strip())  # print cut line end '\n'
                commit_fp.write(temp_data)

            print("=====================================================================")
            print("commit template created and store in: " + commit_file_path)
            return True
    else:
        print("commit template file missing...")
        return False


# program run start here
print("CUR_PATH: ")
print("\t ---> " + cur_work_abs_path)

usr_val = do_shell_cmd("ls -all")
if (-1 != usr_val):
    print(usr_val)

print("Software Version: " + VERSION)

print("support commit type:")
for key, value in commit_type_dic.items():
    print(key + ". " + value)
print("================================")

loop_time = 0
commit_template_created_flag = False
commit_check_finished_flag = False

while (False == commit_check_finished_flag) and (False == commit_template_created_flag) and (loop_time < 3):
    loop_time += 1

    if is_file_exist(commit_file_path):
        format_commit_file(commit_file_path)
        print("\nCurrent commit msg:\n")
        read_and_print_file(commit_file_path)
        print("Do you need current commit file message to commit")
        user_input = input("Enter y or n: ")

        if (user_input.lower() == "help"):
            print(help_info_container_dic["help"])
            exit(1)
        elif (user_input == 'Y') or (user_input == 'y'):
            print("do_format_check_and_commit")
            ret_val = format_check_commit(commit_file_path)
            if ret_val:
                commit_check_finished_flag = True
                do_commit(commit_file_path)
                break
            else:
                commit_check_finished_flag = True
                print(
                    "----------------------- fomat check failed -----------------------")
                break
        elif (user_input == 'N') or (user_input == 'n'):
            tmp_shell_cmd = "rm -vf " + commit_file_path
            do_shell_cmd(tmp_shell_cmd)
        else:
            continue
    else:
        loop_ticks = 0
        while loop_ticks < 3:
            loop_ticks += 1
            input_value = input("please choose the type, integer: ")
            try:
                input_num = int(input_value)
                # check input integer is in range map
                map_len = list(commit_type_dic)
                # print("map_len:" + str(len(map_len)))

                if (input_num <= len(map_len)):
                    print("you have choosed: " + commit_type_dic[input_value])
                    get_and_create_match_template(commit_type_dic[input_value])
                    loop_ticks = 0
                    commit_template_created_flag = True
                    break
                else:
                    print("input numberr out of range 1 ~ " + str(len(map_len)))
                    continue
                break
            except:
                print("input error")
                # pass
        if loop_ticks == 3:
            exit(-1)

# if __name__ == '__main__':

######################################### END LINE #########################################
