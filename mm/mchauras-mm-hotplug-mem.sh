#!/bin/bash

# Function to retrieve system's total memory size in bytes
get_total_memory() {
    grep MemTotal /proc/meminfo | awk '{print $2 * 1024}'
}

# Function to check if a memory block is online
is_memory_online() {
    online_file="$1"
    if [ -e "$online_file" ]; then
        content=$(cat "$online_file")
        if [ "$content" = "1" ]; then
            return 0  # Memory block is online
        fi
    fi
    return 1  # Memory block is not online
}

# Check if desired memory size is provided as argument
if [ -z "$1" ]; then
    echo "Usage: $0 <desired_memory_in_GB>"
    exit 1
fi

# Desired total memory size in bytes (calculated from argument)
desired_mem=$(( $1 * 1024 * 1024 * 1024 ))

# Check if total memory is greater than desired amount
if [ "$(get_total_memory)" -gt "$desired_mem" ]; then
    echo "Total memory is greater than desired amount. Offlining memory blocks."
    for mem_block in /sys/devices/system/memory/memory*; do
        online_file="$mem_block"/online
        if [ -e "$online_file" ]; then
            if is_memory_online "$online_file"; then
                echo "offline > $online_file"
                echo offline > "$online_file"
                echo  "$(get_total_memory) - $desired_mem"
                if [ "$(get_total_memory)" -le "$desired_mem" ]; then
                    break 2  # Break both loops
                fi
            fi
        fi
    done
    echo "Total memory reached desired amount."
else
    echo "Total memory is less than or equal to desired amount. Onlining memory blocks."
    # Online memory blocks until total memory reaches desired amount
    for mem_block in /sys/devices/system/memory/memory*; do
        online_file="$mem_block"/online
        if [ -e "$online_file" ]; then
            if ! is_memory_online "$online_file"; then
                echo "online > $online_file"
                echo online > "$online_file"
                if [ "$(get_total_memory)" -ge "$desired_mem" ]; then
                    break 2  # Break both loops
                fi
            fi
        fi
    done
    echo "Total memory reached desired amount."
fi

