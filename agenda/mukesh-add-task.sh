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

# Emacs Lisp code to add the task
EMACS_LISP_CODE=$(cat <<EOF
(require 'org)
(find-file "$ORG_FILE")
(goto-char (point-max))
(insert "* TODO $TASK_DESCRIPTION\n")
(insert "  DEADLINE: <${NEXT_DAY}>")
(save-buffer)
(kill-emacs)
EOF
)

# Run Emacs in batch mode with the Elisp code
emacs -batch -l ~/.spacemacs -e "$EMACS_LISP_CODE"

