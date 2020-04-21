
@echo "------------------ serial number ------------------"
@adb shell getprop | findstr serial
@echo "------------------ device code --------------------"
@adb shell getprop | findstr atm
@pause