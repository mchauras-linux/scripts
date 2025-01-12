#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <org_file>"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found!"
    exit 1
fi

# Run Emacs in batch mode to convert Org to HTML
emacs --batch --eval "(require 'org)" "$1" --funcall org-html-export-to-html

# Optionally, you can move the HTML file to a desired location or keep it in the same directory.
# For example, to move the HTML file to the same directory as the Org file:
mv "${1%.org}.html" "$(dirname "$1")"
