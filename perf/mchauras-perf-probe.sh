#!/bin/bash

# Function to display help/usage information
show_help() {
    echo "Usage: $0 [-a function_name] [-r function_name] [-l]"
    echo ""
    echo "Options:"
    echo "  -a function_name  Attach a perf probe to the specified function."
    echo "  -r function_name  Remove the perf probe from the specified function."
    echo "  -l                List all currently attached probes."
    echo "  -h                Display this help message."
    echo ""
    echo "Examples:"
    echo "  $0 -a tcp_v4_connect  # Attach a probe to tcp_v4_connect function."
    echo "  $0 -r tcp_v4_connect  # Remove the probe from tcp_v4_connect function."
    echo "  $0 -l                 # List all attached probes."
    exit 0
}

# Function to check if script is run with sudo
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo "This script must be run as root``." >&2
        exit 1
    fi
}

# Function to attach a perf probe
attach_probe() {
    local function_name=$1
    if [ -z "$function_name" ]; then
        echo "Error: No function name provided for attaching probe."
        exit 1
    fi
    perf probe -a "$function_name"
    if [ $? -eq 0 ]; then
        echo "Probe attached to function '$function_name'."
    else
        echo "Failed to attach probe to function '$function_name'."
    fi
}

# Function to remove a perf probe
remove_probe() {
    local function_name=$1
    if [ -z "$function_name" ]; then
        echo "Error: No function name provided for removing probe."
        exit 1
    fi
    perf probe -d "$function_name"
    if [ $? -eq 0 ]; then
        echo "Probe removed from function '$function_name'."
    else
        echo "Failed to remove probe from function '$function_name'."
    fi
}

# Function to list all active probes
list_probes() {
    perf probe -l
}

# Main script logic

# Check if the script is run with sudo or as root
check_sudo

if [ $# -eq 0 ]; then
    show_help
fi

while getopts ":a:r:lh" opt; do
    case ${opt} in
        a)
            attach_probe "$OPTARG"
            ;;
        r)
            remove_probe "$OPTARG"
            ;;
        l)
            list_probes
            ;;
        h)
            show_help
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            show_help
            ;;
    esac
done

