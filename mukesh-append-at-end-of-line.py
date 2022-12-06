#! /usr/bin/python
import sys

#TODO ask for path and char at runtime

if( len(sys.argv) < 2):
    print("Error: Pass the name of file")
    exit()

filename = sys.argv[1]
#char = input("Enter char to add at end of line: ")
file = open(filename, "r")
f = open("/tmp/myfile.txt", "w")

for line in file:
    line=line.replace("\n","<br>"+ "\n")
    f.write(line)

f.close()
file.close()

