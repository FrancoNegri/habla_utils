#!/usr/bin/python
#Transforms to lab format
import sys
import re
import itertools
import random

from itertools import izip

#this code was made with quick experimentation purposes and should never see the light of day

def main():
	replacement_rules = {}
	if len(sys.argv) != 5:
		usage = 'Use: ./replace_phonemes.py rules.txt in.lab out.lab full/mono'
		print usage
		exit()
	with open(sys.argv[1]) as f:
		for line in f:
			(key, val) = line.split()
			replacement_rules[key] = val
		in_lab = sys.argv[2]
		out_lab = sys.argv[3]
		is_full = sys.argv[4]
		is_full = (is_full == "full")
		ilab = open(in_lab,'r')
		olab = open(out_lab,'w')
		num_lines = sum(1 for line in ilab)
		phones = []
		ilab.seek(0)
		

		times_init = []
		times_end = []
		extra_feat = []
		for idx, line1 in enumerate(ilab):
			tokens = line1.split()
			times_init.append(tokens[0])
			times_end.append(tokens[1])
			if is_full:
				phone = tokens[2].split('-')[1].split('+')[0]
				extra_feat.append(tokens[2].split('@')[1:])
			else:
				phone = tokens[2]
				extra_feat.append('')
			#replece phones
			if phone in replacement_rules:
				phone = replacement_rules[phone]
			#half /r become /rr
			if phone == 'r':
				if random.randint(0,1):
					phone = 'rr'
			if phone == 'hh':
				if random.randint(0,1):
					phone = 'g'
			if phone == 's':
				if random.randint(0,1):
					phone = 'th'
			phones.append(phone)
		
		ilab.seek(0)
		#adhoc solution for phone ny -> when /n followed by /i, transform to -> /ny
		new_phones = []
		new_times_init = []
		new_times_end = []
		new_extra_feat = []
		skip = False
		for i in range(0,len(phones)):
			if not skip:
				if i + 1 < len(phones):
					if phones[i] == 'n' and phones[i+1] == 'i':
						new_phones.append("ny")
						new_times_init.append(times_init[i])
						new_times_end.append(times_end[i+1])
						new_extra_feat.append(extra_feat[i])
						#skip next phone
						skip = True
						print "Found /ny"
					else:
						new_phones.append(phones[i])
						new_times_init.append(times_init[i])
						new_times_end.append(times_end[i])
						new_extra_feat.append(extra_feat[i])
				else:
					new_phones.append(phones[i])
					new_times_init.append(times_init[i])
					new_times_end.append(times_end[i])
					new_extra_feat.append(extra_feat[i])
			else:
				skip = False			
		phones = new_phones
		times_init = new_times_init
		times_end = new_times_end
		extra_feat = new_extra_feat
		#add two nil at start
		phones = ["nil", "nil"] + phones
		#add two nil phones for the fullcontext case
		phones = phones + ["nil", "nil"]
		width = 8
		for idx in range(0,len(phones)-4):
			if is_full:
				olab.write("  " + times_init[idx].ljust(width," ") + " " + times_end[idx].ljust(width," ") + " " + phones[idx] + '^' + phones[idx+1] + '-' + phones[idx+2] + '+' + phones[idx+3] + '=' + phones[idx+4] + '@' + "@".join(extra_feat[idx]) + "\n")
			else:
				olab.write("  " + times_init[idx].ljust(width," ") + " " + times_end[idx].ljust(width," ") + " " + phones[idx+2] + "\n")

if __name__ == "__main__":
	main()