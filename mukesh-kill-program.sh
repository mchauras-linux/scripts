#! /bin/bash
if [ $# -lt 1 ]
then
	echo "Pass the name of program to kill"
	exit -1
fi

PROG=$1

function kill_program {
#	KILL_PROG_PID=`ps -ax | grep $PROG | awk '{print $1}' | head -n 1`
#	KILL_PROG_NAME=`ps -ax | grep $PROG | awk '{$1=$2=$3=$4=""; print $0}' | head -n 1`
	RES="DUMMY"
	RED='\033[0;31m' # RED Color
	NC='\033[0m' # No Color
	while true
	do
		if [ "$RES" = "Y" -o "$RES" = "y" ]
		then
			kill -9 $KILL_PROG_PID
			if [ $? -eq 0 ]
			then
				echo -e "Killed $KILL_PROG_NAME\n"
			else
				echo -e "Cannot Kill $KILL_PROG_NAME\n"
			fi
			break
		elif [ "$RES" = "N" -o "$RES" = "n" ]
		then
			break
		else
			echo -e "Do you want to kill ${RED}$KILL_PROG_NAME${NC} (Y/n): "
			read RES < /dev/tty
		fi
	done
}

PROCESSES_TO_KILL=$(ps -ax | grep $PROG | head -n-3 )

while IFS= read -r line;
do
	KILL_PROG_PID=$(echo $line | awk '{print $1}')
	KILL_PROG_NAME=$(echo $line | awk '{$1=$2=$3=$4=""; print $0;}')
	kill_program
done <<< "$PROCESSES_TO_KILL"
