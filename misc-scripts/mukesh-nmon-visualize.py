#! /usr/bin/python3

import sys
import os
import matplotlib.pyplot as plt

plt.rcParams.update({'font.size': 18})  # Set the font size globally
fig, axes = plt.subplots(2, 2, figsize=(60, 30))
(cpuplt, vmplt), (memplt, rpplt) = axes
file_path = ""

def read_rp_data(file_path):
    iterations = []
    run_thr = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith('PROC'):
                parts = line.split(',')
                iteration_part = parts[1]
                if iteration_part.startswith('T'):
                    iteration = int(iteration_part[1:])  # Extract the iteration number (removing the initial 'T')
                    r_t = float(parts[2])
                    iterations.append(iteration)
                    run_thr.append(r_t)
    return iterations, run_thr

def plot_rp_data(iterations, r_t):
    global file_path
    rpplt.plot(iterations, r_t, label='Runnable Threads', color='red')
    rpplt.set_xlabel('Iteration')
    rpplt.set_ylabel('Runnable Threads')
    rpplt.set_title(file_path)
    rpplt.legend()
    rpplt.grid(True)

def read_mem_data(file_path):
    iterations = []
    mem_free = []
    mem_total = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith('MEM'):
                parts = line.split(',')
                iteration_part = parts[1]
                if iteration_part.startswith('T'):
                    iteration = int(iteration_part[1:])  # Extract the iteration number (removing the initial 'T')
                    mem_t = float(parts[2]) - float(parts[6])  # Idle percentage
                    mem_f = float(parts[6])  # Idle percentage
                    iterations.append(iteration)
                    mem_total.append(mem_t)
                    mem_free.append(mem_f)
    return iterations, mem_total, mem_free

def plot_mem_data(iterations, mem_used, mem_free):
    global file_path
    memplt.plot(iterations, mem_used, label='Mem Used', color='black')
    memplt.plot(iterations, mem_free, label='Mem Free', color='red')
    memplt.set_xlabel('Iteration')
    memplt.set_ylabel('Memory')
    memplt.set_title(file_path)
    memplt.legend()
    memplt.grid(True)

def read_vm_data(file_path):
    iterations = []
    pgfaults = []
    pgallocs = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith('VM'):
                parts = line.split(',')
                iteration_part = parts[1]
                if iteration_part.startswith('T'):
                    iteration = int(iteration_part[1:])  # Extract the iteration number (removing the initial 'T')
                    pgfault = float(parts[15])  # Idle percentage
                    pgalloc = float(parts[25])  # Idle percentage
                    iterations.append(iteration)
                    pgallocs.append(pgalloc)
                    pgfaults.append(pgfault)
    return iterations, pgfaults, pgallocs

# Function to plot the data and save the plot
def plot_vm_data(iterations, pgf, pga):
    global file_path
    vmplt.plot(iterations, pgf, label='Page Faults', color='black')
    vmplt.plot(iterations, pga, label='Page Allocs', color='red')
    vmplt.set_xlabel('Iteration')
    vmplt.set_ylabel('Faults and Allocs')
    vmplt.set_title(file_path)
    vmplt.legend()
    vmplt.grid(True)

# Function to read the file and extract relevant data
def read_cpu_data(file_path):
    iterations = []
    busy_percentages = []
    idle_percentages = []
    sys_per = []
    wait_per = []
    user_per = []

    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith('CPU_ALL'):
                parts = line.split(',')
                iteration_part = parts[1]
                if iteration_part.startswith('T'):
                    iteration = int(iteration_part[1:])  # Extract the iteration number (removing the initial 'T')
                    idle = float(parts[5])  # Idle percentage
                    busy = 100 - float(parts[5])  # Calculate busy percentage (100% - idle%)
                    syst = float(parts[3])
                    wait = float(parts[4])
                    user = float(parts[2])
                    iterations.append(iteration)
                    busy_percentages.append(busy)
                    idle_percentages.append(idle)
                    sys_per.append(syst)
                    wait_per.append(wait)
                    user_per.append(user)

    return iterations, busy_percentages, idle_percentages, sys_per, wait_per, user_per

# Function to plot the data and save the plot
def plot_cpu_data(iterations, busy, idle, syst, wait, user):
    global file_path
    cpuplt.plot(iterations, busy, label='Busy %', color='red')
    cpuplt.plot(iterations, idle, label='Idle %', color='orange')
    cpuplt.plot(iterations, wait, label='Wait %', color='blue')
    cpuplt.plot(iterations, syst, label='Sys %', color='black')
    cpuplt.plot(iterations, user, label='User %', color='green')
    cpuplt.set_xlabel('Iteration')
    cpuplt.set_ylabel('CPU %')
    cpuplt.set_title(file_path)
    cpuplt.legend()
    cpuplt.grid(True)

def remove_all_extensions(filename):
    while '.' in filename:
        filename = filename.rsplit('.', 1)[0]
    return filename

# Main function to run the program
def main():
    if len(sys.argv) != 2:
        print("Usage: python cpu_plot.py <file_path>")
        sys.exit(1)
    global file_path 
    file_path = sys.argv[1]
    iterations, busy, idle, syst, wait, user = read_cpu_data(file_path)
    plot_cpu_data(iterations, busy, idle, syst, wait, user)

    iterations, pgfaults, pgallocs = read_vm_data(file_path)
    plot_vm_data(iterations, pgfaults, pgallocs)

    iterations, mem_total, mem_free = read_mem_data(file_path)
    plot_mem_data(iterations, mem_total, mem_free)
    
    iterations, r_p = read_rp_data(file_path)
    plot_rp_data(iterations, r_p)
    
    plt.savefig(remove_all_extensions(file_path)) 
    plt.show()

if __name__ == '__main__':
    main()

