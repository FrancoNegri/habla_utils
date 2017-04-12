#!/usr/bin/python
#Transforms to lab format
import sys
import re
import itertools

#####
#Gets a monophone lab and a fullcontext/mono lab, and merge the phone times of the first one with the ones of the second ones
####

def main():
    usage = 'Usage: ./generator.py good_lab bad_lab output_lab'
    if len(sys.argv) != 4:
        print usage
        exit()
    good_lab = sys.argv[1]
    bad_lab = sys.argv[2]
    output = sys.argv[3]

    glab = open(good_lab,'r')
    blab = open(bad_lab,'r')
    olab = open(output, 'w')
    width = 8
    for line1, line2 in itertools.izip(glab, blab):
    	line1_aux = line1.split()
    	line2_aux = line2.split()
    	olab.write("  " + line1_aux[0].ljust(width," ") + " " + line1_aux[1].ljust(width," ") + " " + line2_aux[2] + "\n")

if __name__ == "__main__":
    main()