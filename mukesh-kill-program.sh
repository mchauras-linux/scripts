#! /bin/bash
if [ $# -lt 1 ]
then
	echo "Pass the name of program to kill"
	exit -1
fi

export KILL_PROG_PID=`ps -ax | grep $1 | awk '{print $1}' | head -n 1`
export KILL_PROG_NAME=`ps -ax | grep $1 | awk '{print $5}' | head -n 1`
RES="DUMMY"
RED='\033[0;31m' # RED Color
NC='\033[0m' # No Color
while true
do
	if [ "$RES" = "Y" ]
	then
		kill -9 $KILL_PROG_PID
		if [ $? -eq 0 ]
		then
			echo "Killed $KILL_PROG_NAME"
		else
			echo "Cannot Kill $KILL_PROG_NAME"
		fi
		break
	elif [ "$RES" = "n" ]
	then
		break
	else
		echo -e "Do you want to kill ${RED}$KILL_PROG_NAME${NC} (Y/n): "
		read RES
	fi
done
