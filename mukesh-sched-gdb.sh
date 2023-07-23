#! /bin/bash

gdb							                \
	-ex "file /home/mchauras/src/linux-mchauras/vmlinux"		\
	-ex 'set print pretty on'					\
	-ex 'set logging enabled on'					\
	-ex 'set trace-command on'					\
	-ex 'target remote localhost:1234'				\
	-ex 'break wake_up_new_task'					\
	-ex 'break kernel_clone'					\
	-ex 'break __wake_up'						\
	-ex 'break flush_smp_call_function_queue'			\
	-ex 'break resched_curr'					\
	-ex 'break schedule'						\
	-ex 'break scheduler_tick'					\
	-ex 'break kernel_thread'					\
	$@								\
	-ex 'continue'
