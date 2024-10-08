#!/bin/bash

PERF_EVENTS="instructions,cpu-clock,cycles,L1-icache-loads,L1-icache-load-misses,L1-icache-prefetches,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-prefetches,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,LLC-prefetches,pm_exec_stall,cache-misses,cache-references,pm_cmpl_stall,pm_disp_held_cyc"

PERF_CMD="perf stat -e $PERF_EVENTS -r 1"

# Command to run with each value
for value in off 2 4 6 8; do
    echo "Running with value: $value"
    ppc64_cpu --smt=$value
    #ppc64_cpu --info
    EBIZZY_C= $PERF_CMD ./run_ebizzy_with_perf.sh &
    wait
    if [[ "$value" == 4 || "$value" == 6 || "$value" == 8 ]]; then
    	EBIZZY_C=1 $PERF_CMD ./run_ebizzy_with_perf.sh &
    	wait
    fi
done

