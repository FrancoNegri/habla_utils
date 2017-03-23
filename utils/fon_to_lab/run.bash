#!/bin/bash
for f in *.wav
do
	./fon_to_lab.py "${f%%.*}".fon "${f%%.*}".wav "${f%%.*}".lab 
	echo "${f%%.*}"
done