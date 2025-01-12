#!/usr/bin/python

import os
import sys
import subprocess
from optparse import OptionParser

#assumes that cpustr is of the form CPUXX
def cpuint(cpustr):
    return int(cpustr[3:])
    
def parse_proc_interrupts(filename):
    ret_dict = {}
    name_dct = {}
    fp = open(filename, "r")
    lines=fp.readlines()
    fp.close()

    #first line contains the CPU numbers
    cpus_str = lines[0].split()
    cpus = list(map(cpuint, cpus_str))
    for cpu in cpus:
        ret_dict[cpu] = {}

    idx=0
    for line in lines[1:]:
        irq_nr = line.split(':')[0] + ",%d" %(idx)
        idx += 1
        try:
            values = line.split(':')[1].split()
        except IndexError:
            print("File %s weird line" %(filename))
            print(line)
            exit
            
        try:
            name_dct[irq_nr] = ' '.join(word for word in values[len(cpus):])
        except:
            print("CPU %d, irq_nr %s. No values\n" %(cpus[i], irq_nr))
            name_dct[irq_nr] =''
            
        for i in range(0, len(cpus)):
            try:
                ret_dict[cpus[i]][irq_nr] = int(values[i])
            except:
                #print "Got an exception at index %d for CPU %d , %s" %(i, cpus[i], irq_nr)
                ret_dict[cpus[i]][irq_nr] = 0

    return (ret_dict, name_dct)

def delta_interrupts(before_dict, after_dict):
    ret_dict = {}
    for cpu in list(before_dict.keys()):
        ret_dict[cpu] = {}
        for irq_nr in list(before_dict[cpu].keys()):
            try:
                ret_dict[cpu][irq_nr] = after_dict[cpu][irq_nr] - before_dict[cpu][irq_nr]
            except:
                print("After dict doesn't contain irq %s for CPU%d" %(irq_nr, cpu))

    return ret_dict

parser=OptionParser(usage="%prog -b proc_interrupts_before_file -a proc_interrupts_after_file", version="%prog 1.0",
                    description="""Parses the contents of proc_interrupts_before_file and proc_interrupts_after file and prints the interrupts received on on each of the CPUs as a diff of these two""")
parser.add_option("-b", "--before", action="store", dest="before_file",
                  default="/proc/interrupts",help="snapshot of /proc/interrupts before running the command")
parser.add_option("-a", "--after", action="store", dest="after_file",
                  default="/proc/interrupts",help="snapshot of /proc/interrupts after running the command")

(options,args) = parser.parse_args()

before_file=options.before_file
after_file=options.after_file

before_dct,irq_names=parse_proc_interrupts(before_file)

after_dct,irq_names=parse_proc_interrupts(after_file)

delta_dct = delta_interrupts(before_dct, after_dct)

cpus = list(delta_dct.keys())
cpus.sort()
for cpu in cpus:
    print("CPU %d :" %(cpu))
    total_irqs=0
    for irq_nr in list(delta_dct[cpu].keys()):
        if (delta_dct[cpu][irq_nr] != 0):
            total_irqs = total_irqs + delta_dct[cpu][irq_nr]
            print("\t\t %s [%s] = %d times" %(irq_nr.split(',')[0], irq_names[irq_nr], delta_dct[cpu][irq_nr]))
    print(("\t\t Total IRQs = %d" %(total_irqs)))
