#!/bin/bash

kill_cores() {
	core_count=$1
	total_cpu_count=$(nproc --all)
	timestamp=$(date)

	echo "[${timestamp}] Leaving ${core_count} out of ${total_cpu_count} cores enabled..." >> /var/log/killcores_suspend_hook.log

	for ((i = 0; i < total_cpu_count; i++)); do
		echo 1 >"/sys/devices/system/cpu/cpu${i}/online"
	done

	for ((i = core_count; i < total_cpu_count; i++)); do
		echo 0 >"/sys/devices/system/cpu/cpu${i}/online"
	done
}

case $1 in
pre) kill_cores 1 ;;
post) kill_cores $(nproc --all) ;;
esac
