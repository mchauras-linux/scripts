#! /usr/bin/python3

import os

def get_cpu_affinity_mask(task_path):
    """Get CPU affinity of a process or thread."""
    try:
        with open(f'{task_path}/status') as f:
            for line in f:
                if line.startswith('Cpus_allowed'):
                    return line.split(':')[1].strip()
    except FileNotFoundError:
        return None

def get_cpu_affinity(task_path):
    """Get CPU affinity of a process or thread."""
    try:
        with open(f'{task_path}/status') as f:
            for line in f:
                if line.startswith('Cpus_allowed_list'):
                    return line.split(':')[1].strip()
    except FileNotFoundError:
        return None

def get_process_name(pid):
    """Get the name of the process."""
    try:
        with open(f'/proc/{pid}/comm') as f:
            return f.readline().strip()
    except FileNotFoundError:
        return None

def list_threads():
    """List all threads in the system, their process name, and their CPU affinity."""
    pids = [pid for pid in os.listdir('/proc') if pid.isdigit()]

    # Header
    print(f'{"PID":<10} {"Process Name":<70} {"TID":<10} {"CPU Affinity":<13} {"CPU Affinity Mask"}')
    print('-' * 140)

    for pid in pids:
        process_name = get_process_name(pid)
        if not process_name:
            continue

        task_path = f'/proc/{pid}/task'
        if os.path.exists(task_path):
            tids = os.listdir(task_path)
            for tid in tids:
                affinity = get_cpu_affinity(f'{task_path}/{tid}')
                affinity_mask = get_cpu_affinity_mask(f'{task_path}/{tid}')
                if affinity:
                    print(f'{pid:<10} {process_name:<70} {tid:<10} {affinity:<18} {affinity_mask}')

if __name__ == '__main__':
    list_threads()

