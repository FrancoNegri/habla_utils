#!/bin/bash
mkdir full
mkdir mono
for f in mono/*.lab
do
	filename=$(basename $f)
	./generator.py new_labs/$filename full_bad_times/$filename full/$filename
	./generator.py new_labs/$filename mono_bad_times/$filename mono/$filename
	echo $filename
done