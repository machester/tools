# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import linecache

VERSION = "1.0"
UPGRADE_DATE = "2021-07-01"
LOG_FILE_NAME = "fake.log"

DEBUG_SWITCH = True

def debugInfo(str = ""):
	if DEBUG_SWITCH:
		print(str)

class Duplication:
	curWorkPath = " "
	transferredTargetPath = " "
	duplicate_name_head = "fake_"
	searchParameter = ""
	# searchParameter = "gc8034_mipi_raw"
	searchResultDirStr = ""
	searchResultDirList = []
	logFilePath = ""

	def __init__(self):
		pass

	def DoShellCmd(self, shellCmd):
		try:
			res = subprocess.Popen(shellCmd, shell = True, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
			lines = res.stdout.read()  # read cmd ouput
			lines.decode('utf-8')  # decode
			res.wait()  # wait cmd
			res.stdout.close()  # close std out
			return lines
		except BaseException as e:
			print("error: shell cmd: " + shellCmd)
			return -1

	def isFileExist(self, path_name):
		try:
			if not (os.path.exists(path_name)):
				print(path_name + " not exist")
				return False
			else:
				# print ( "exist" )
				return True
		except FileNotFoundError:
			print("error: path name or format")
			return LookupError

	def read_and_print_file(self, path_name):
		with open(path_name, "rt", encoding = "UTF-8") as fp:
			print("============================== INFORMATION ==============================")
			for line_data in fp:
				print(line_data.strip())  # readline and delete last '\n'
			print("=========================================================================")

	def find_repo_path_create_commit_file_path(self):
		global commit_file_path
		global temp_commit_file_path
		global tmp_file_folder

		tmp_path = cur_work_abs_path
		"""find .repo"""
		dir_var_list = tmp_path.split("/")
		dir_deep_index = len(dir_var_list)
		dir_loop_ticks = len(dir_var_list)
		index = 0
		while index < int(len(dir_var_list)):
			index += 1
			dir_deep_index = dir_deep_index - 1
			# print("tmp_path:" + tmp_path)
			dir_list = os.listdir(tmp_path)
			for dirs in dir_list:
				if ".repo" == dirs:
					commit_file_path = tmp_path
					dir_deep_index = 0
					break

			if (len(commit_file_path.strip()) > 0):
				# print("find .repo in path: " + commit_file_path )
				tmp_file_folder = commit_file_path
				temp_commit_file_path = commit_file_path + "/" + "donot_write_" + commit_file_name
				commit_file_path = commit_file_path + "/" + commit_file_name
				return True
			else:
				# print("dir_var_list[" + str(dir_deep_index) + "] = " + dir_var_list[dir_deep_index])
				tmp_path = tmp_path.rstrip(dir_var_list[dir_deep_index])
				tmp_path = tmp_path.rstrip("/")
				if (len(tmp_path.strip()) <= 0):
					break
		# print("---> tmp_path: " + tmp_path)
		return False

	def showAllParam(self):
		print("curWorkPath: " + self.curWorkPath)
		print("transferredTargetPath: " + self.transferredTargetPath)
		print("searchParameter: " + self.searchParameter)

	def FindAndPrepare(self):
		strShellCmd = "find . -name " + self.searchParameter
		ret_value = self.DoShellCmd(strShellCmd)
		self.searchResultDirStr = str(ret_value, 'utf-8').rstrip('\n')
		debugInfo("--------------------------------- FIND RESULT ---------------------------------")
		debugInfo(ret_value)
		debugInfo(type(ret_value))
		debugInfo("-------------------------------------------------------------------------------")
		if len(ret_value.strip()) <= 0:
			return
		# delete space and split search result dir
		self.searchResultDirStr.strip()
		self.searchResultDirList = str(self.searchResultDirStr).split("\n")
		# delete searchParameter
		for loopIndex in range(len(self.searchResultDirList)):
			self.searchResultDirList[loopIndex] = self.searchResultDirList[loopIndex].lstrip("./")
			self.searchResultDirList[loopIndex] = self.searchResultDirList[loopIndex].rstrip(self.searchParameter)

			debugInfo("searchResultDirList[ " + str(loopIndex) + " ]: " + self.searchResultDirList[loopIndex])

		debugInfo("--------------------------------- self.searchResult ---------------------------------")
		debugInfo(self.searchResultDirList)
		debugInfo("len: " + str(len(self.searchResultDirList)))
		debugInfo("-------------------------------------------------------------------------------")

if __name__ == '__main__':
	if len(sys.argv) < 2:
		debugInfo("error: Miss transferred find dir")
		exit(-1)
	elif len(sys.argv) < 3:
		debugInfo("error: Miss transferred find name")
		exit(-1)

	fake = Duplication()
	fake.transferredTargetPath = os.path.realpath(str(sys.argv[1]))
	fake.curWorkPath = os.path.realpath('.')
	fake.searchParameter = sys.argv[2]
	if not fake.isFileExist(fake.transferredTargetPath):
		debugInfo()
		exit(0)
	fake.showAllParam()
	fake.logFilePath = os.path.join(fake.curWorkPath, LOG_FILE_NAME)
	fake.FindAndPrepare()
	with open(fake.logFilePath, "wt", encoding = "UTF-8") as fp:
		# log file
		for loopIndex in range(len(fake.searchResultDirList)):
			fp.write(fake.searchResultDirList[loopIndex])

	print("-------------------------- END ---------------------")
