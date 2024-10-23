#! /bin/bash

# Author Srikar Dronamraju
# Email: srikar@linux.ibm.com

for i in $@; do
	shift
	[[ $i = *=* ]] && eval $i && continue
	if [[ $i = "-x" ]]
	then
		export SHDEBUG=-x
		continue
	fi
	if [[ $i = "-v" ]]
	then
		export SHVERBOSE=-v
		continue
	fi
	if [[ $i = "-f" ]]
	then
		export FORCE=1
		continue
	fi
	set -- $@ $i
done
test -n "$SHDEBUG" && set -x && SHDEBUG=-x
test -n "$SHVERBOSE" && set -v && SHVERBOSE=-v

# source ~/bin/libtrace.sh

function setup()
{
	CMD=ebizzy

	KERNREL=$(uname -r)
	RELEASE=$(awk '{print $1; exit}' /lib/modules/${KERNREL}/series)
	cd ~/src/linux.git
	test -n "$RELEASE" &&
	       	TMPRELEASE=$(git describe --tags $RELEASE --exclude=MY* --exact-match)
	RELEASE=${TMPRELEASE:-$RELEASE}
	RELEASE=${RELEASE:-"distro"}
	NR_CPUS=$(nproc)
	cd

	DIR="output/$(hostname -s)/${KERNREL%+}/${RELEASE}/${CMD}"
	#Cmd,real,User,System,voluntary cs, involuntary cs, major, minor fault
	TIME="%C\t%e\t%U\t%S\t%c\t%w\t%F\t%R"
	CACHE_EVENTS="cycles,instructions,cs,migrations,faults,PM_RUN_CYC_ST_MODE,PM_RUN_CYC_SMT2_MODE,PM_RUN_CYC_SMT4_MODE"
	SCHED_EVENTS="sched:sched_waking,sched:sched_wakeup,sched:sched_wakeup_new"
	PERF_EVENTS="-e $CACHE_EVENTS -e $SCHED_EVENTS"
	ITERS=${ITERS:-5}

	SADC=$(type -P sadc 2>/dev/null)
	SADC=${SADC:-/usr/lib64/sa/sadc}
	SADC=${SADC:-/usr/lib/sysstat/sadc}

	DURATION=${DURATION:-30}
}

function cleanup()
{
	rm -f $DIR/tmp* $DIR/results.txt $DIR/time* $DIR/*
}

function install()
{
	echo "Yet to be implemented"
}

function prerun()
{
	EBIZZY=${EBIZZY:-$(type -P ebizzy 2>/dev/null)}
	EBIZZY=${EBIZZY:-~/work/ebizzy.git/ebizzy}
	test -x $EBIZZY || install
	test -x $EBIZZY || {
		exit 1;
	}
	test -z "$FORCE" && test -d "$DIR" && echo existing $DIR && exit
	mkdir -p $DIR
	test -f $DIR/../series || cat /lib/modules/${KERNREL}/series > $DIR/../series
	echo 4 | sudo tee /proc/sys/kernel/printk
	echo 1 | sudo tee /proc/sys/kernel/sched_schedstats

	cleanup

	#tmux splitw -d -v htop -d 5
	#tmux splitw -d -h 'top -i -H -d 5 -n 20'

}

function postrun()
{
	echo 0 | sudo tee /proc/sys/kernel/sched_schedstats
	#pkill top
	#pkill htop
}

function run()
{
	prerun

	t=$(($NR_CPUS/2))
	while [ $t -le $(($NR_CPUS/2)) ]; do

		PAT=_${t}
		echo "Kernel : $KERNREL($RELEASE)" > $DIR/results${PAT}.txt
		PERF_ARGS="--append -o $DIR/perf_stat${PAT}.txt $PERF_EVENTS"
		PERF_STAT_CMD="sudo perf stat -r $ITERS $PERF_ARGS --"
		TIME_CMD="/usr/bin/time -f $TIME -a -o $DIR/time_${CMD}${PAT}.txt --"

		type -P lparstat >& /dev/null && {
			lparstat 5 100000 > $DIR/lparstat${PAT}.txt &
			LPARSTATPID=$!
		}
		cat /proc/schedstat >  $DIR/schedstat_before${PAT}.txt
		cat /proc/interrupts >  $DIR/interrupts_before${PAT}.txt
		cat /proc/softirqs > $DIR/softirqs_before${PAT}.txt
		[ -s "$SADC" ] && {
			$SADC -S ALL 1 100000  $DIR/sar${PAT}.bin &
			SARPID=$!
		}

		EBIZZY_CMD="$EBIZZY -t $t -S $DURATION"
		$PERF_STAT_CMD $TIME_CMD ${EBIZZY_CMD} |& grep records | tee -a $DIR/tmp_results${PAT}.txt

		cat /proc/schedstat >  $DIR/schedstat_after${PAT}.txt
		cat /proc/interrupts >  $DIR/interrupts_after${PAT}.txt
		cat /proc/softirqs > $DIR/softirqs_after${PAT}.txt
		type -P lparstat >& /dev/null && kill $LPARSTATPID
		[ -s "$SADC" ] && kill $SARPID

		sed -i -e 's/\s\+$//g' $DIR/perf_stat${PAT}.txt
		t=$(($t*2))
	done

	postrun
}

function postprocess()
{
	t=$(($NR_CPUS/2))
	while [ $t -le $(($NR_CPUS/2)) ]; do
		PAT=_${t}
		~/bin/schedstat-15.pl -tcd $DIR/schedstat_before${PAT}.txt $DIR/schedstat_after${PAT}.txt > $DIR/schedstat_diff${PAT}.txt
		cat $DIR/tmp_results${PAT}.txt >> $DIR/results${PAT}.txt
		echo >> $DIR/results${PAT}.txt
		ministat -n $DIR/tmp_results${PAT}.txt | tee -a $DIR/results${PAT}.txt
		echo >> $DIR/results${PAT}.txt
		awk '{print $1}' $DIR/tmp_results${PAT}.txt | textogram | sed 's/\s\+$//g' | tee -a $DIR/results${PAT}.txt
		sar -f $DIR/sar${PAT}.bin -w -q -u -P ALL >& $DIR/sar${PAT}.txt
		t=$(($t*2))
	done
}

setup
if [ $# -gt 0 ]; then
	for i in $@; do
		shift
		$i
	done
else
	run
	postprocess
fi
