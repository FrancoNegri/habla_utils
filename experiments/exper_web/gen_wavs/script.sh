for i in {0..4}
do
	mkdir wav/$i
	for f in lab/*.lab
	do
		filename=$(basename "$f")
		extension="${filename##*.}"
		filename="${filename%.*}"
		arctic_per=$(awk -v i=$i 'BEGIN { print i*25/100 }')
		loc1_per=$(awk -v i=$i 'BEGIN { print (100 -i*25)/100 }')
		com="hts_engine -m models/cmu_us_arctic_slt.htsvoice -m models/loc1_pal.htsvoice -i 2 $arctic_per $loc1_per -ow wav/$i/$filename.wav $f"
		echo $com
		eval $com
	done
done