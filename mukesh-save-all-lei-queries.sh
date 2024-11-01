#!/bin/bash

SAVED_SEARCHES_DIR="$HOME/.local/share/lei/saved-searches"
OUTPUT_BASE_DIR="$HOME/.mails"

# Display usage information
usage() {
	  echo "Usage: $0 --export <file> | --import <file>"
	  echo "  --export <file>   Export all saved searches to the specified file"
	  echo "  --import <file>   Import saved searches from the specified file and run them"
	  exit 1
}

# Export function to save all saved-search files to a single file
export_queries() {
	  local backup_file="$1"

    # Clear or create the backup file
    > "$backup_file"

    if [[ ! -d "$SAVED_SEARCHES_DIR" ]]; then
	      echo "No saved searches directory found at '$SAVED_SEARCHES_DIR'."
	      exit 1
    fi

    # Loop through each saved search directory and concatenate the lei.saved-search content
    for search_dir in "$SAVED_SEARCHES_DIR"/*; do
	      if [[ -f "$search_dir/lei.saved-search" ]]; then
		        echo "Exporting from: $search_dir"
		        cat "$search_dir/lei.saved-search" >> "$backup_file"
		        echo -e "\n" >> "$backup_file"  # Add a newline for separation
	      fi
    done

    echo "All saved searches exported to '$backup_file'."
}

# Import function to run all queries from a file
import_queries() {
	local backup_file="$1"

	if [[ ! -f "$backup_file" ]]; then
		echo "No backup file found at '$backup_file'."
		exit 1
	fi
	# Initialize parameters for the current query
	local include=""
	local dedupe=""
	local output=""
	local query=""
	while IFS= read -r line; do
		if [[ -n $(grep -oP '^\s*include\s*=\s*\K.*' <<< "$line") ]]; then
			include=$(grep -oP '^\s*include\s*=\s*\K.*' <<< "$line")
		elif [[ -n $(grep -oP '^\s*dedupe\s*=\s*\K.*' <<< "$line") ]]; then
			dedupe=$(grep -oP '^\s*dedupe\s*=\s*\K.*' <<< "$line")
		elif [[ -n $(grep -oP '^\s*output\s*=\s*\K.*' <<< "$line") ]]; then
			output=$(grep -oP '^\s*output\s*=\s*maildir:\s*\K.*' <<< "$line")
		elif [[ -n $(grep -oP '^\s*q\s*=\s*\K.*' <<< "$line") ]]; then
			query=$(grep -oP '^\s*q\s*=\s*\K.*' <<< "$line")
		fi
		if [[ -n "$include" && -n "$dedupe" && -n "$output" && -n $query ]]; then
			echo "Running: lei q -I $include -o $output --threads --dedupe=$dedupe \"$query\""
			lei q -I "$include" -o "$output" --threads --dedupe="$dedupe" "$query"

			# Initialize parameters for the current query
			local include=""
			local dedupe=""
			local output=""
			local query=""
		fi
	done < "$backup_file"
}

# Check for required arguments
if [[ $# -lt 2 ]]; then
	  usage
fi

# Handle command-line options
case "$1" in
	  --export)
		    if [[ -z "$2" ]]; then
			      echo "Please specify a file to export queries."
			      usage
		    fi
		    export_queries "$2"
		    ;;
	  --import)
		    if [[ -z "$2" ]]; then
			      echo "Please specify a file to import queries."
			      usage
		    fi
		    import_queries "$2"
		    ;;
	  *)
		    usage
		    ;;
esac

