import os
import sys
import threading
import time
import datetime
from queue import Queue
import subprocess

class WifiTest:
    iperf_cmd_client = "iperf -c 127.0.0.1 -t 20 -i 1 | tee log_client.log &"
    iperf_cmd_server = "iperf -s | tee log_server.log &"
    currentPath = ""
    logFileName = ""
    logPathFile = ""
    msg_queue = Queue()

    def __init__(self):
        self.currentPath = os.getcwd()
        self.logFileName = "wifi_test_log_" + time.strftime('%Y%m%d_%H%M%S', time.localtime(time.time())) + ".log"
        self.logPathFile = os.path.join(self.currentPath, self.logFileName)

    def Class_Info(self):
        print("------------------------ Information ----------------------------")
        print("* current thread run on linux system")
        print("* require python version >= 3.6")
        print("-----------------------------------------------------------------")

    def do_cmd(self, cmd):
        try:
            res = subprocess.Popen(cmd, shell = True, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
            lines = res.stdout.read()  # read cmd ouput
            lines.decode('utf-8')  # decode
            res.wait()  # wait cmd
            res.stdout.close()  # close std out
            return lines
        except:
            print("error: shell cmd: " + cmd)
            return -1

    # def Test_GetAdbDevices(self):
    #     devices_info = os.system("adb devices")
    #     print(devices_info)
    #     time.sleep(5)

    def Test_GetAdbDevices(self):
        # devices_info = os.popen("adb devices").readlines()
        devices_info = self.do_cmd("adb devices")
        print("-----------------------------------------------------------------")
        print(devices_info)
        print("-----------------------------------------------------------------")
        # time.sleep(2)

    def Test_LogFile(self, msg_queue):
        if os.path.exists(self.logPathFile):
            print("file exist: " + self.logPathFile)
            self.logFileName = "wifi_test_log_" + time.strftime('%Y%m%d_%H%M%S', time.localtime(time.time())) + ".log"

        print("in thread:" + threading.currentThread().getName(), ", log path: ", self.logPathFile)
        while True:
            with open(self.logPathFile, 'a+', encoding = "UTF-8") as logFp:
                msg = msg_queue.get()
                print("---> get: " + msg)
                logInfo = time.asctime(time.localtime(time.time())) + ": " + msg + "\n"
                print(logInfo)
                logFp.write(logInfo)

    # def NetOperation(self, msg_queue):
    #     print("in thread:" + threading.currentThread().getName())
    #     while True:
    #         print("<--- put: test")
    #         msg_queue.put("test")
    #         print("size:{}\n".format(msg_queue.qsize()))
    #         time.sleep(1)

    def Test_Iperf_server(self, msg_queue):
        server_ret = self.do_cmd(self.iperf_cmd_server)
        tmp_str = "server_ret: " + str(server_ret) + "\n"
        print("server_ret: " + tmp_str)
        msg_queue.put(tmp_str)
        time.sleep(1)

    def Test_Iperf_client(self, msg_queue):
        client_ret = self.do_cmd(self.iperf_cmd_client)
        tmp_str = "client_ret: " + str(client_ret) + "\n"
        print("client_ret: " + tmp_str)
        msg_queue.put(tmp_str)
        time.sleep(1)

    def NetOperation(self, msg_queue):
        print("in thread:" + threading.currentThread().getName())
        tmpShellCmd = "iperf -s"
        run_mark = 1
        while True:
            # print("<--- put: test")
            # msg_queue.put("test")
            # print("size:{}\n".format(msg_queue.qsize()))
            # time.sleep(1)


            iperf_server_thread = threading.Thread(target = test.Test_Iperf_server, args = (test.msg_queue,))
            iperf_client_thread = threading.Thread(target = test.Test_Iperf_client, args = (test.msg_queue,))
            iperf_server_thread.start()
            iperf_client_thread.start()
            iperf_server_thread.join()
            iperf_client_thread.join()
            print("iperf finished")

            time.sleep(1)



    def Show_Graphic(self):
        pass

    def log_info(self, log_file):
        pass

if __name__ == '__main__':
    test = WifiTest()
    test.Class_Info()
    test.Test_GetAdbDevices()

    print("1: " + test.currentPath)
    print("2: " + test.logFileName)
    print("3: " + test.logPathFile)

    operationThread = threading.Thread(target = test.NetOperation, args = (test.msg_queue,))
    # log file create
    logThread = threading.Thread(target = test.Test_LogFile, args = (test.msg_queue,))
    operationThread.start()
    logThread.start()

    operationThread.join()
    logThread.join()
