#!/bin/bash

# Check if the script is running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Function to print the total number of CPUs
get_total_cpus() {
    grep -c '^processor' /proc/cpuinfo
}

# Get the total number of CPUs
total_cpus=$(get_total_cpus)
echo "Total CPUs before hotplug: $total_cpus"

# Function to toggle hotplug state for specific number of CPUs
toggle_hotplug_state() {
    local num_cpus=$1

    for ((cpu=1; cpu<num_cpus; cpu++)); do
        # Check if the CPU is online before attempting to change its state
        if [ -e "/sys/devices/system/cpu/cpu$cpu/online" ]; then
            echo 1 > "/sys/devices/system/cpu/cpu$cpu/online"
            echo "CPU $cpu online."
        else
            echo "CPU $cpu is not hotpluggable or does not exist."
        fi
    done
}

# Function to offline additional CPUs if needed
offline_additional_cpus() {
    local num_cpus_requested=$1

    if [ "$total_cpus" -gt "$num_cpus_requested" ]; then
        for ((cpu=num_cpus_requested; cpu<=total_cpus; cpu++)); do
            if [ -e "/sys/devices/system/cpu/cpu$cpu/online" ]; then
                echo 0 > "/sys/devices/system/cpu/cpu$cpu/online"
                echo "CPU $cpu offline."
            else
                echo "CPU $cpu is not hotpluggable or does not exist."
            fi
        done
    fi
}

# Check if the user provided correct parameters
if [ $# -ne 1 ]; then
    echo "Usage: $0 <num_cpus>"
    exit 1
fi

num_cpus_requested="$1"

# Validate that num_cpus_requested is a positive integer
if ! [[ "$num_cpus_requested" =~ ^[1-9][0-9]*$ ]]; then
    echo "Invalid num_cpus_requested. Please provide a positive integer."
    exit 1
fi

# Offline additional CPUs if the total number is greater than the requested number
offline_additional_cpus "$num_cpus_requested"

# Toggle hotplug state for the specified number of CPUs
toggle_hotplug_state "$num_cpus_requested"

# Wait for a moment to let the system recognize the changes
sleep 2

# Confirm the new total number of CPUs
total_cpus_after=$(get_total_cpus)
echo "Total CPUs after hotplug: $total_cpus_after"

