
@echo ------------------ cpu current freq  ----------------------------
@adb shell cat sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
@echo -----------------------------------------------------------------
@echo ------------------ cpu support cpu freq list --------------------
@adb shell cat sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
@pause