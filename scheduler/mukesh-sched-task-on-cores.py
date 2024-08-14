#! /usr/bin/python3

import subprocess
import os

SMT=8
NPROC=64
core_fd = []
dir_name = 'task_on_core_report'
cpu_data = [""] * NPROC
core = []

def get_core_info():
    # Run the ppc64_cpu --info command
    result = subprocess.run(['ppc64_cpu', '--info'], capture_output=True, text=True)
    output = result.stdout
    
    # Dictionary to store logical CPU to core mapping
    output = output.replace("*", "")
    # Parse the output line by line
    for line in output.splitlines():
        line= line.split()
        line[1] = line[1].replace(":", "")
        line = line[1:]
        core.insert(int(line[0]), [int(x) for x in line[1:]])

def get_cpu_core(cpu_id):
    if not core:
        get_core_info()

    for i, cpu_list in enumerate(core):
        if cpu_id in cpu_list:
            return i
    return None

def is_float(string):
    try:
        float(string)
        return True
    except ValueError:
        return False

def create_incremental_directory():
    global dir_name
    # Initialize the directory name
    directory_name = dir_name
    index = 1

    # Check if the directory exists and increment if it does
    while os.path.exists(directory_name):
        directory_name = f"{dir_name}_{index}"
        index += 1

    # Create the unique directory
    os.mkdir(directory_name)
    dir_name = directory_name
    print(f"Directory '{directory_name}' created successfully!")

def is_valid_index(lst, index):
    try:
        value = lst[index]
        return True
    except IndexError:
        return False

def parse_line(line):
    match = line.split()
    if is_float(match[0]):
        timestamp = float(match[0])
        cpu = int(match[1].split(":")[0])
        core = int(match[1].split(":")[1])
        process_info = match[2]
        return timestamp, core, cpu, process_info
    return None

def generate_report(input_file):
    with open(input_file, 'r') as infile:
        for line in infile:
            parsed_line = parse_line(line)
            if not parsed_line:
                continue
            timestamp, core, cpu, comm = parsed_line
            if not is_valid_index(core_fd, core):
                core_fd.insert(core, open(dir_name + '/core_' + str(core), 'w'))
            
            cpu_data[cpu] = comm
            core_fd[core].write(str(timestamp))
            core_fd[core].write(",")
            line_data = [","] * SMT
            for i in range(SMT):
                index = (core * SMT) + i
                line_data[i] = cpu_data[index]

            core_fd[core].write(','.join(line_data))
            core_fd[core].write("\n")


if __name__ == "__main__":
    input_file = './logs/cpu_process_report.txt'  
    
    # Create the directory
    create_incremental_directory()
    generate_report(input_file)
    print(dir_name)
