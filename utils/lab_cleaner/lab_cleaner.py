#!/usr/bin/python

#Cleans labs: cleans multiple "#" phones in fullcontext lab
#Warning, times will end up being non continuous, but for this specific script I don't care

import sys
import re
import subprocess

usage = 'Usage: ./lab_cleaner.py input.lab output.lab'

if len(sys.argv) != 3:
    print usage
    exit()

ifname = sys.argv[1]
ofname = sys.argv[2]

inf = open(ifname, 'r')
outf = open(ofname, 'w')

# get info from .lab
start_parsing = False
prev_lavel = ""
for line in inf:
    tokens = line.split()
    label = tokens[2].split("-")[1].split("+")[0]
    if(prev_lavel == label == "#"):
        continue
    outf.write(line)
    prev_lavel = label
inf.close()
outf.close()