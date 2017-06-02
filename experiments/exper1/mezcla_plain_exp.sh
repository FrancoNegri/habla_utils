 #!/bin/bash
 #Para este experimento planteo diferentes proporciones en la interpolacion entre los modelos castellano/ingles
for i in {1..9}
do
   echo "hts_engine -m models/cmu_us_arctic_slt.htsvoice -m models/loc1_pal.htsvoice -i 2 0.$i 0.$((10-$i)) -ow wav/interpolacion$i-$((10-$i)).wav labs/p_1 sus_p_00004.lab"
   hts_engine -m models/cmu_us_arctic_slt.htsvoice -m models/loc1_pal.htsvoice -i 2 0.$i 0.$((10-$i)) -ow wav/interpolacion$i-$((10-$i)).wav labs/p_1 labs/sus_p_00004.lab 
done