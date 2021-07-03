# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import linecache
import shutil

VERSION = "1.0"
UPGRADE_DATE = "2021-07-01"
LOG_FILE_NAME = "fake.log"

DEBUG_SWITCH = True

def debugInfo(str = ""):
	if DEBUG_SWITCH:
		print(str)

def help():
	print("---------------------------------- HELP -------------------------------------------")
	print("Format: python3 copy_and_rename_camera.py  <search dir> <folder name> <keywords need to rename>")
	print("example: ")
	print("\tpython3 copy_and_rename_camera.py  ~/work/jiangq/MTK/android10/o109/alps/vendor/mediatek/proprietary gc8034_mipi_raw gc8034")
	print("-----------------------------------------------------------------------------------")

class Duplication:
	curWorkPath = " "
	transferredTargetPath = " "
	duplicateFileNameHead = "fake_"
	searchParameter = ""
	# searchParameter = "gc8034_mipi_raw"
	replaceNameMark = ""
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

	def showAllParam(self):
		print("curWorkPath: " + self.curWorkPath)
		print("transferredTargetPath: " + self.transferredTargetPath)
		print("searchParameter: " + self.searchParameter)
		print("duplicateFileNameHead: " + self.duplicateFileNameHead)
		print("replaceNameMark: " + self.replaceNameMark)

	def FindAndPrepare(self):
		strShellCmd = "find " + self.transferredTargetPath + " -name " + self.searchParameter
		ret_value = self.DoShellCmd(strShellCmd)
		self.searchResultDirStr = str(ret_value, 'utf-8').rstrip('\n')
		# debugInfo("--------------------------------- FIND RESULT ---------------------------------")
		# debugInfo(ret_value)
		# debugInfo(type(ret_value))
		# debugInfo("-------------------------------------------------------------------------------")
		if len(ret_value.strip()) <= 0:
			return
		# delete space and split search result dir
		self.searchResultDirStr.strip()
		self.searchResultDirList = str(self.searchResultDirStr).split("\n")
		# delete searchParameter
		for loopIndex in range(len(self.searchResultDirList)):
			# self.searchResultDirList[loopIndex] = self.searchResultDirList[loopIndex].lstrip("./")
			self.searchResultDirList[loopIndex] = self.searchResultDirList[loopIndex].rstrip(self.searchParameter)
			debugInfo("searchResultDirList[ " + str(loopIndex) + " ]: " + self.searchResultDirList[loopIndex])

	# debugInfo("--------------------------------- self.searchResult ---------------------------------")
	# debugInfo(self.searchResultDirList)
	# debugInfo("len: " + str(len(self.searchResultDirList)))
	# debugInfo("-------------------------------------------------------------------------------")

	def DuplicateFile(self):
		for loopIndex in range(len(self.searchResultDirList)):
			srcFilePath = self.searchResultDirList[loopIndex] + self.searchParameter
			targetPath = self.searchResultDirList[loopIndex] + self.duplicateFileNameHead + self.searchParameter
			debugInfo("srcFilePath: " + srcFilePath)
			debugInfo("targetPath: " + targetPath)
			debugInfo("-----------------------------------------------------------")
			if os.path.exists(targetPath):
				shutil.rmtree(targetPath)
			shutil.copytree(srcFilePath, targetPath)

	def ReplaceSpecificStr(self, filePath = ""):
		"""sed -i "s/gc8034/fake_gc8034/g" `grep -rl gc8034 .`"""
		strShellCmd = "sed -i s/" + self.replaceNameMark + "/" + self.duplicateFileNameHead + self.replaceNameMark + "/g " + filePath
		self.DoShellCmd(strShellCmd)
		strShellCmd = "sed -i s/" + self.replaceNameMark.upper() + "/" + self.duplicateFileNameHead.upper() + self.replaceNameMark.upper() + "/g " + filePath
		self.DoShellCmd(strShellCmd)
	###########################################################
	# with open ("filePath", "w", encoding = "UTF-8") as filp:
	# 	with open (filePath, "r+", encoding = "UTF-8") as filp:
	# 		for line_index, linedata in enumerate(filp, start = 1):
	# 			linedata.replace(self.replaceNameMark, self.duplicateFileNameHead + self.replaceNameMark)

	# os.path.isdir()
	###########################################################################
	# def RenameFile(self):
	# 	targetDirName = self.duplicateFileNameHead + self.searchParameter
	# 	for loopIndex in range(len(self.searchResultDirList)):
	# 		targetPath = self.searchResultDirList[loopIndex] + targetDirName + "/"
	# 		for root, dirs, files in os.walk(targetPath):
	# 			for listFile in files:
	# 				targetFileName = listFile.replace(self.replaceNameMark, self.duplicateFileNameHead + self.replaceNameMark)
	# 				debugInfo("targetFileName: " + targetFileName)
	# 				os.rename(targetPath + listFile, targetPath + targetFileName)
	#
	# 			for listDirs in dirs:
	# 				subDirsFiles = os.path.join(root, listDirs)
	# 				debugInfo("subDirsFiles: " + subDirsFiles)
	# 				targetFileName = subDirsFiles.replace(self.replaceNameMark, self.duplicateFileNameHead + self.replaceNameMark)
	# 				debugInfo("subDirs targetFileName: " + subDirsFiles)
	# 				os.rename(subDirsFiles, targetPath + targetFileName)
	############################################################################
	# def RenameFile(self):
	# 	targetDirName = self.duplicateFileNameHead + self.searchParameter
	# 	for loopIndex in range(len(self.searchResultDirList)):
	# 		targetPath = self.searchResultDirList[loopIndex] + targetDirName + "/"
	# 		targetDir = os.listdir(targetPath)
	# 		for file in targetDir:
	# 			debugInfo("operate file: " + targetPath + file)
	# 			self.ReplaceSpecificStr(targetPath + file)
	# 			if self.replaceNameMark in file:
	# 				targetFileName = file.replace(self.replaceNameMark, self.duplicateFileNameHead + self.replaceNameMark)
	# 				debugInfo("targetFileName: " + targetFileName)
	# 				os.rename(targetPath + file, targetPath + targetFileName)
	##############################################################################

	def RenameFile(self):
		targetDirName = self.duplicateFileNameHead + self.searchParameter
		for loopIndex in range(len(self.searchResultDirList)):
			dirFilesList = []
			targetPath = self.searchResultDirList[loopIndex] + targetDirName
			debugInfo("targetPath: " + targetPath)
			# list all targetDir files include subdir files
			for root, dirs, files in os.walk(targetPath):
				for listFile in files:
					dirFilesList.append(os.path.join(root, listFile))

			# for name in dirFilesList:
			# 	debugInfo(name)
			# cut path index
			for fileName in dirFilesList:
				# debugInfo("src file: " + fileName)
				tmpStr = fileName[len(targetPath) + 1:]
				# debugInfo("debugInfo:" + tmpStr)
				# rename replaceNameMark in file
				self.ReplaceSpecificStr(fileName)

				if self.replaceNameMark in tmpStr:
					targetFileName = tmpStr.replace(self.replaceNameMark, self.duplicateFileNameHead + self.replaceNameMark)
					# debugInfo("fileName: " + tmpStr)
					# debugInfo("targetFileName: " + targetFileName)
					os.rename(fileName, os.path.join(targetPath, targetFileName))
					debugInfo("file: " + os.path.join(targetPath, targetFileName))

if __name__ == '__main__':
	if "help" == sys.argv[1].lower():
		help()
		exit(-1)
	elif len(sys.argv) < 2:
		debugInfo("error: Miss transferred find dir")
		exit(-1)
	elif len(sys.argv) < 3:
		debugInfo("error: Miss transferred find name")
		exit(-1)

	fake = Duplication()
	fake.transferredTargetPath = os.path.realpath(str(sys.argv[1]))
	fake.curWorkPath = os.path.realpath('.')
	fake.searchParameter = sys.argv[2]
	fake.replaceNameMark = sys.argv[3]
	if not fake.isFileExist(fake.transferredTargetPath):
		debugInfo()
		exit(0)

	fake.showAllParam()
	fake.logFilePath = os.path.join(fake.curWorkPath, LOG_FILE_NAME)
	fake.FindAndPrepare()
	with open(fake.logFilePath, "wt", encoding = "UTF-8") as fp:
		# log file
		for loopIndex in range(len(fake.searchResultDirList)):
			fp.write(fake.searchResultDirList[loopIndex] + "\n")

	fake.DuplicateFile()
	fake.RenameFile()
	print("-------------------------- END ---------------------")
