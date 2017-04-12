#!/bin/bash
mkdir new_full
for f in *.lab
do
	filename=$(basename $f)
	./replace_phonemes.py $filename new_full/$filename full
	echo $filename
done