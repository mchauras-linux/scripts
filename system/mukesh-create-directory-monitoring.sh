#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Usage:"
	echo "`basename $0` <directory> <abs(exec)>"
	echo "Put it in init script for use after reboot"
	exit 1
fi

LOG_FILE="/home/$USER/monitor_log"

file_removed() {
    echo "[$TIMESTAMP]: $2 was removed from $1"  >> $LOG_FILE
    $3
}

file_modified() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]: The file $1$2 was modified" >> $LOG_FILE
    $3
}

file_created() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]: The file $1$2 was created" >> $LOG_FILE
    $3
}

inotifywait -q -m -r -e modify,delete,create $1 | while read DIRECTORY EVENT FILE; do
    case $EVENT in
        MODIFY*)
            file_modified "$DIRECTORY" "$FILE" $2
            ;;
        CREATE*)
            file_created "$DIRECTORY" "$FILE" $2
            ;;
        DELETE*)
            file_removed "$DIRECTORY" "$FILE" $2
            ;;
    esac
done
