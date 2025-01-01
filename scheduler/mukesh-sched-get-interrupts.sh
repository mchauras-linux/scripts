#!/bin/bash

# Check if a command is provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 <command_to_run>"
  exit 1
fi

# Calculate total interrupts before running the command
before=$(awk '{for(i=2;i<=NF;i++) sum+=$i} END {print sum}' /proc/interrupts)

# Run the provided command
"$@"

# Calculate total interrupts after running the command
after=$(awk '{for(i=2;i<=NF;i++) sum+=$i} END {print sum}' /proc/interrupts)

# Calculate and print the difference
interrupts=$((after - before))
echo "Interrupts during execution: $interrupts"

