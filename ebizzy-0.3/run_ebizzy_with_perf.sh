#!/bin/bash

# Check if any arguments are passed
if [ $# -eq 0 ]; then
    echo "Usage: $0 <perf_command> <perf_args...>"
fi
TH=8
RM_PERF=n
NR_PROC=12
ITER=10
OP_DIR=logs/`date +'%Y-%m-%d_%H-%M-%S'`

mkdir -p $OP_DIR
echo -e "For logs check `pwd`/$OP_DIR"
# Store the entire perf command with all arguments
#PERF_CMD="$@"
#PERF_CMD="perf stat -e $PERF_EVENTS -r 5"

# Use the EBIZZY_C environment variable for the -c value, leave blank if not set
if [ -n "$EBIZZY_C" ]; then
    EBIZZY_C_ARG="-c"
else
    EBIZZY_C_ARG=""
fi

echo "Running warmup for 20 secs"
#./ebizzy $EBIZZY_C_ARG -t $TH &> /dev/null
#./ebizzy $EBIZZY_C_ARG -t $TH &> /dev/null
for i in $(seq 1 $ITER); do
	for i in $(seq 1 $NR_PROC); do
		#CMD="$PERF_CMD -o perfebizzy$i ./ebizzy $EBIZZY_C_ARG -t $TH -s 4096"
		CMD="$PERF_CMD ./ebizzy $EBIZZY_C_ARG -t $TH -s 65536"
		echo -e "$CMD"
		$CMD >> $OP_DIR/ebizzy_$i &
	done
	# Wait for both jobs to finish
	wait
done
AVG_REC=$(./get_ebizzy_records $OP_DIR)
#cat ebizzy_*
if [ "$RM_PERF" = "y" ]; then
	#cat perfebizzy*
	rm perfebizzy*
	rm ebizzy_*
fi
echo "*************************************************************************"
if [ -n "$EBIZZY_C" ]; then
	echo -e "Core Sched: Enabled"
else
	echo -e "Core Sched: Disabled"
fi
echo -e "EBIZZY Processes: $NR_PROC"
echo -e "EBIZZY Threads: $TH"
echo -e "$AVG_REC"
echo "*************************************************************************"
