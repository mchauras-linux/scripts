# Linux Kernel

start_kernel
arch_call_rest_init

## RUST in Kernel

[Linux Doc for RUST](https://docs.kernel.org/rust/quick-start.html)
make LLVM=1 rustavailable
rustup override set $(scripts/min-tool-version.sh rustc)

## GDB Command

qemu-system-x86_64 -s -S -nographic					\
-smp cores=2								\
-kernel ./vmlinux							\
-initrd ../busybox/ramdisk.img						\
-nic user,model=rtl8139,hostfwd=tcp::5555-:23,hostfwd=tcp::5556-:8080

gdb							                \
	-ex "file vmlinux"						\
	-ex 'target remote localhost:1234'				\
	-ex 'break wake_up_new_task'					\
	-ex 'break kernel_clone'					\
	-ex 'break __wake_up'						\
	-ex 'break flush_smp_call_function_queue'			\
	-ex 'break resched_curr'					\
	-ex 'break schedule'						\
	-ex 'break tick_sched_timer'					\
	-ex 'continue'
