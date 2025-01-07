#!/bin/bash

# Get the kernel's clock ticks per second (jiffies per second)
HZ=$(getconf CLK_TCK)

# Function to convert jiffies to nanoseconds
jiffies_to_ns() {
  local jiffies=$1
  echo $((jiffies * 1000000000 / HZ))
}

# Define the ordered list of IRQ types
ORDERED_IRQ_TYPES=("total" "hi" "timer" "net_tx" "net_rx" "block" "irq_poll" "tasklet" "sched" "hrtimer" "rcu")

# Map soft IRQ names to their corresponding fields
declare -A IRQ_TYPES=(
  ["total"]=2
  ["hi"]=3
  ["timer"]=4
  ["net_tx"]=5
  ["net_rx"]=6
  ["block"]=7
  ["irq_poll"]=8
  ["tasklet"]=9
  ["sched"]=10
  ["hrtimer"]=11
  ["rcu"]=12
)

# Function to display help message
display_help() {
  echo "Usage: $0 [OPTION]"
  echo "Display the time spent in IRQs (in nanoseconds) from /proc/stat."
  echo
  echo "Options:"
  echo "  --help          Display this help message."
  for irq in "${ORDERED_IRQ_TYPES[@]}"; do
    echo "  $irq            Show time spent in $irq IRQs."
  done
  echo
  echo "If no option is given, all values are displayed in sequence."
  exit 0
}

# Check for the --help parameter
if [[ $1 == "--help" ]]; then
  display_help
fi

# Parse /proc/stat to get soft IRQ data
read -r total_irq hi timer net_tx net_rx block irq_poll tasklet sched hrtimer rcu < <(awk '/^softirq/ {for (i=2; i<=NF; i++) printf "%s ", $i}' /proc/stat)

# Store values in an array for easy access
SOFTIRQ_VALUES=("$total_irq" "$hi" "$timer" "$net_tx" "$net_rx" "$block" "$irq_poll" "$tasklet" "$sched" "$hrtimer" "$rcu")

# If a specific parameter is given, display only that
if [[ -n $1 ]]; then
  param=$1
  if [[ -n ${IRQ_TYPES[$param]} ]]; then
    field_index=$((IRQ_TYPES[$param] - 2))
    value_ns=$(jiffies_to_ns "${SOFTIRQ_VALUES[$field_index]}")
    echo "${param^} IRQ time (ns): $value_ns"
  else
    echo "Invalid parameter. Use --help for valid options."
    exit 1
  fi
else
  # Print all values in a defined sequence
  echo "IRQ Times (in nanoseconds):"
  for irq in "${ORDERED_IRQ_TYPES[@]}"; do
    field_index=$((IRQ_TYPES[$irq] - 2))
    value_ns=$(jiffies_to_ns "${SOFTIRQ_VALUES[$field_index]}")
    printf "%-10s: %s\n" "${irq^}" "$value_ns"
  done
fi

