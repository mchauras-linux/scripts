#! /bin/bash

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
	if [[ $i = "-c" ]]
	then
		export CLEANUP=1
		continue
	fi
	set -- $@ $i
done

function setup()
{
	echo "Needs Setup"
}

function prerun()
{
	echo "Needs Prerun"
}

function run()
{
	echo "Needs run"
}

function postrun()
{
	echo "Needs post run"
}

function postprocess()
{
	echo "Needs post process"
}

function cleanup()
{
	echo "Needs cleanup"
}

setup
prerun
run
postrun
postprocess

if [ ${CLEANUP:-0} -eq 1 ]; then
	cleanup
fi
