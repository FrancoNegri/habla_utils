#!/usr/bin/python

#converts fon format to mono lab

import sys
import re
import subprocess

usage = 'Usage: ./lab_to_textgrid.py input.fon input.wav output.lab'

if len(sys.argv) != 4:
    print usage
    exit()

ifname = sys.argv[1]
wavname = sys.argv[2]
ofname = sys.argv[3]

inf = open(ifname, 'r')
outf = open(ofname, 'w')

# get info from .lab
start_parsing = False
labs = [("0","#")]
for line in inf:
    if not re.search('^\s*Tiempo\s*Color\s*Label', line) and not start_parsing:
        continue
    else:
    	if not start_parsing:
        	start_parsing = True
        	continue
    tokens = line.split()
    label = tokens[2].strip()
    time = tokens[0].strip()
    labs.append((string(float(time)*1000000), label))


f = open("temp.txt", "w+")
subprocess.call(['/home/franckn/htk/habla_utils/utils/praat/praat', '--run', 'praat_script', wavname],stdout=f)
f.seek(0)
end_time = f.read().split()[0]
labs.append((string(float(end_time)*1000000),"#"))

count = 0
prevtime = '0'
width = 8
for i in range(0,len(labs)-1):
    outf.write('  ' + labs[i][0].ljust(width," ") + '   ' + labs[i+1][0].ljust(width," ") + '   ' + labs[i][1] + '\n')

inf.close()
outf.close()