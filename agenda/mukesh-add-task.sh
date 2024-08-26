#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <task description>"
    exit 1
fi

# Path to the Org file
ORG_FILE="$HOME/scripts/agenda/agenda.org"

# Combine all command-line arguments into a single task description
TASK_DESCRIPTION="$*"

# Get the next day's date in Org mode format
NEXT_DAY=$(date -d "tomorrow" +"%Y-%m-%d")

echo -e "** TODO $TASK_DESCRIPTION" >> $ORG_FILE
echo -e "DEADLINE: <${NEXT_DAY}>\n" >> $ORG_FILE

