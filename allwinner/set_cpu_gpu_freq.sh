#!/system/bin/sh
adb root
adb remount
echo "---> start set"
adb shell echo 1080000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
adb shell echo 504000000 > /sys/devices/gpu/devfreq/gpu/min_freq
echo "---> end  set "
echo "---> current cpu gpu status:"
echo "CPU:"
adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "GPU:"
adb shell cat /sys/devices/gpu/devfreq/gpu/min_freq
