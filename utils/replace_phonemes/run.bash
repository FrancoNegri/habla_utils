#!/bin/bash
mkdir new_mono
for f in *.lab
do
	filename=$(basename $f)
	./replace_phonemes.py $filename new_mono/$filename mono
	echo $filename
done