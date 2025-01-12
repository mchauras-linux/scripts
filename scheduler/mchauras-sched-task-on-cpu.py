#! /usr/bin/python3

import subprocess
core = []

def get_uname_info():
    # Run the uname -a command
    result = subprocess.run(['uname', '-a'], capture_output=True, text=True)
    
    # Return the command's output as a string
    return result.stdout

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

# Function to parse a line of the trace log
def parse_trace_line(line):
    match = line.split()
    if is_float(match[0]):
        timestamp = float(match[0])
        cpu = int(match[1].replace("[", "").replace("]",""))
        process_info = ' '.join(map(str, match[2:-3])).replace(" ", "")
        exec_time = float(match[-3])
        syscall_time = float(match[-2])
        total_time = float(match[-1])
        return timestamp, cpu, process_info, exec_time, syscall_time, total_time
    return None

# Function to generate a report from the trace log
def generate_report(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        outfile.write(get_uname_info())
        outfile.write(f"{'Timestamp':<15} {'CPU:Core':<9} {'Process/Thread':<30} {'Execution Time':<15} {'Syscall Time':<15} {'Total Time':<15}\n")
        outfile.write("="*95 + "\n")

        for line in infile:
            parsed_line = parse_trace_line(line)
            if parsed_line:
                timestamp, cpu, process_info, exec_time, syscall_time, total_time = parsed_line
                core = get_cpu_core(cpu)
                cpu_info = str(cpu) + ":" + str(core)
                outfile.write(f"{timestamp:<15} {cpu_info:<9} {process_info:<30} {exec_time:<15} {syscall_time:<15} {total_time:<15}\n")

if __name__ == "__main__":
    input_file = 'trace_output.txt'  # Replace with the path to your input trace log file
    output_file = 'cpu_process_report.txt'  # Path to the output report file
    

    generate_report(input_file, output_file)
    print(f"Report generated and saved to {output_file}")

