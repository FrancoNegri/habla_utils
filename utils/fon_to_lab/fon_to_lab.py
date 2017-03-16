#!/usr/bin/python

#converts fon format to mono lab

import sys
import re

usage = 'Usage: ./lab_to_textgrid.py input.fon output.lab'

if len(sys.argv) != 3:
    print usage
    exit()

ifname = sys.argv[1]
ofname = sys.argv[2]

inf = open(ifname, 'r')
outf = open(ofname, 'w')

# get info from .lab
start_parsing = False
labs = []
for line in inf:
    if not re.search('^\s*Tiempo\s*Color\s*Label', line) and not start_parsing:
        continue
    else:
    	if not start_parsing:
        	start_parsing = True
        	continue
    tokens = line.split()
    time = tokens[0].strip()
    label = tokens[2].strip()
    labs.append((time, label))

count = 0
prevtime = '0'
outf.write("#\n")
for elt in labs:
    count += 1
    outf.write(' ' + prevtime + '   ' + elt[0] + '   ' + elt[1] + '\n')
    prevtime = elt[0]

inf.close()
outf.close()