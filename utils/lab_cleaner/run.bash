#!/bin/bash
mkdir new
for f in *.lab
do
	./lab_cleaner.py "${f%%.*}".lab new/"${f%%.*}".lab 
	echo "${f%%.*}"
done