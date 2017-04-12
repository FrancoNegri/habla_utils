#!/usr/bin/python
#Transforms to lab format
import sys
import re
import itertools

def main():
	usage = 'Usage: ./replace_phonemes.py in.lab out.lab full/mono'
	if len(sys.argv) != 4:
		print usage
		exit()
	in_lab = sys.argv[1]
	out_lab = sys.argv[2]
	is_full = sys.argv[3]
	is_full = (is_full == "full")

	ilab = open(in_lab,'r')
	olab = open(out_lab,'w')
	width = 8
	num_lines = sum(1 for line in ilab)
	phones = ["nil", "nil"]
	print "hola"
	ilab.seek(0)
	for idx, line1 in enumerate(ilab):
		tokens = line1.split()
		if is_full:
			phone = tokens[2].split('-')[1].split('+')[0]
			if phone == '#':
				phone = 'sp'
			phones.append(phone)
		else:
			if tokens[2] == "#":
				tokens[2] = "sp"
			olab.write("  " + tokens[0].ljust(width," ") + " " + tokens[1].ljust(width," ") + " " + tokens[2] + "\n")
	if is_full:
		phones.append('nil')
		phones.append('nil')
		ilab.seek(0)
		for idx, line1 in enumerate(ilab):
			features = line1.split('@')
			features.pop(0)
			#print(features)
			times = line1.split()
			olab.write("  " + times[0].ljust(width," ") + " " + times[1].ljust(width," ") + " " + phones[idx] + '^' + phones[idx+1] + '-' + phones[idx+2] + '+' + phones[idx+3] + '=' + phones[idx+4] + '@' + "@".join(features))

if __name__ == "__main__":
	main()