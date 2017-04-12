#!/usr/bin/python
# (pau  - 0 0 0 0 0 0 -) ;; silence
# (a  + l 3 2 - 0 0 -) ;; ari: rosa 
# (e  + l 2 1 - 0 0 -) ;; ari: gest'o
# (i  + l 1 1 - 0 0 -) ;; ari: ni~nera
# (o  + l 2 3 + 0 0 -) ;; ari: zapato
# (u  + l 1 3 + 0 0 -) ;; ari: muchacho

# (iW  + s 1 1 - 0 0 -) ;; ari: iogur (weak vowels in dipthongs)
# (uW  + s 1 3 + 0 0 -) ;; ari: agua, washington (weak vowels in dipthongs)

# (aS + l 3 2 - 0 0 -) ;; ari: mano
# (eS + l 2 1 - 0 0 -) ;; ari: mesa
# (iS + l 1 1 - 0 0 -) ;; ari: pino
# (oS + l 2 3 + 0 0 -) ;; ari: 'opera
# (uS + l 1 3 + 0 0 -) ;; ari: tortura

# (p  - 0 - - - s l -) ;; ari: pollo
# (t  - 0 - - - s d -) ;; ari: torre
# (k  - 0 - - - s v -) ;; ari: casa, kilo, queso
# (b  - 0 - - - s l +) ;; ari: bola, vivir
# (d  - 0 - - - s d +) ;; ari: cada
# (g  - 0 - - - s v +) ;; ari: gato, guerra, wisky (huevo?)

# (f  - 0 - - - f b -) ;; ari: feo
# (s  - 0 - - - f a -) ;; ari: caso, excavar?
# (j  - 0 - - - f v -) ;; ari: mexico, juan, gesto, caja 
# (ch - 0 - - - a p -) ;; ari: muchacho
# (th - 0 - - - f d -) ;; ari: cebolla, zapato 

# (m  - 0 - - - n l +) ;; ari: mano
# (n  - 0 - - - n a +) ;; ari: nada
# (ny - 0 - - - n p +) ;; ari: ni~na

# (l  - 0 - - - l a +) ;; ari: lado
# (y  - 0 - - - l p +) ;; ari: coyote, ya (callar, llorar)
# (r  - 0 - - - l a +) ;; ari: trozo
# (rr - 0 - - - l a +) ;; ari: rosa, carro

def main():
	#Extraigo todas las features que necesito
	all_ = []

	vocales = []
	consonantes = []

	vocales_cortas = []
	vocales_largas = []
	dipthongos = []
	schwa = [] #ni idea que es esto
	high_height_vowel = []
	mid_height_vowel = []
	low_height_vowel = []
	front_frontness_vowel = []
	mid_frontness_vowel = []
	back_frontness_vowel = []
	lip_plus = []
	lip_minus = []
	lip_cero = []

	stop = []
	fricative = [] 
	affricative = []
	nasal = []
	liquid = []

	labial = []
	alveolar  = []
	paletal  = []
	labioDental  = []
	dental  = []
	velar = []

	consonant_plus = []
	consonant_minus = []

	phone_file = open('phones.txt', 'r')
	for line in phone_file:
		line = line.replace("(","").replace(")","").split(";;", 1)
		features = line[0].split()
		if not features:
			continue
		print features
		all_.append(features[0])
		if features[1] is "+":
			vocales.append(features[0])
			# ;; 2 vowel length: short long dipthong schwa
			# (vlng s l d a 0)
			if features[2] is "s":
				vocales_cortas.append(features[0])
			elif features[2] is "l":
				vocales_largas.append(features[0])
			elif features[2] is "d":
				dipthongos.append(features[0])
			elif features[2] is "a":
				schwa.append(features[0])

			# ;; 3 vowel height: high mid low
			# (vheight 1 2 3 - 0)
			if features[3] is "1":
				high_height_vowel.append(features[0])
			elif features[3] is "2":
				mid_height_vowel.append(features[0])
			elif features[3] is "3":
				low_height_vowel.append(features[0])
			# ;; 4 vowel frontness: front mid back
			# (vfront 1 2 3 - 0)
			if features[4] is "1":
				front_frontness_vowel.append(features[0])
			elif features[4] is "2":
				mid_frontness_vowel.append(features[0])
			elif features[4] is "3":
				back_frontness_vowel.append(features[0])

		else:
			if features[0] == "sp":
				continue
			consonantes.append(features[0])
			#   ;; 6 consonant type: stop fricative affricative nasal liquid
			# (ctype s f a n l 0)
			if features[6] is "s":
				stop.append(features[0])
			elif features[6] is "f":
				fricative.append(features[0])
			elif features[6] is "a":
				affricative.append(features[0])
			elif features[6] is "n":
				nasal.append(features[0])
			elif features[6] is "l":
				liquid.append(features[0])
			# ;; 7 place of articulation: labial alveolar palatal labio-dental
			# ;; dental velar
			#   (cplace l a p b d v 0)
			if features[7] is "l":
				labial.append(features[0])
			elif features[7] is "a":
				alveolar.append(features[0])
			elif features[7] is "p":
				paletal.append(features[0])
			elif features[7] is "b":
				labioDental.append(features[0])
			elif features[7] is "d":
				dental.append(features[0])
			elif features[7] is "v":
				velar.append(features[0])
			# ;; 8 consonant voicing
			#   	(cvox + - 0)
			if features[8] is "+":
				consonant_plus.append(features[0])
			elif features[8] is "-":
				consonant_minus.append(features[0])

		# ;; 5 lip rounding
		#   (vrnd + - 0)
		if features[5] is "+":
			lip_plus.append(features[0])
		elif features[5] is "-":
			lip_minus.append(features[0])
		elif features[5] is "0":
			lip_cero.append(features[0])

	#Escribo las features de manera linda y ordenada

	lugares = ["LL","L","C","R","RR"]
	prefix = ["","*^","*-","*+","*="]
	postfix = ["^*","-*","+*","=*","@*"]
	output = open('questions_qst001.hed', 'w')


	for i in range(0,5):
		lugar = lugares[i]
		prefijo = prefix[i]
		postfijo = postfix[i]

		escribir(output,lugar,"Vowel",vocales,prefijo,postfijo)
		escribir(output,lugar,"Consonant",consonantes,prefijo,postfijo)

		escribir(output,lugar,"Stop",stop,prefijo,postfijo)
		escribir(output,lugar,"Nasal",nasal,prefijo,postfijo)
		escribir(output,lugar,"Fricative",fricative,prefijo,postfijo)
		escribir(output,lugar,"Liquid",fricative,prefijo,postfijo)

		escribir(output,lugar,"Front",front_frontness_vowel,prefijo,postfijo)
		escribir(output,lugar,"Central",mid_frontness_vowel,prefijo,postfijo)
		escribir(output,lugar,"Back",back_frontness_vowel,prefijo,postfijo)

		escribir(output,lugar,"Front_Vowel",list(set(vocales) & set(front_frontness_vowel)),prefijo,postfijo)
		escribir(output,lugar,"Central_Vowel",list(set(vocales) & set(mid_frontness_vowel)),prefijo,postfijo)
		escribir(output,lugar,"Back_Vowel",list(set(vocales) & set(back_frontness_vowel)),prefijo,postfijo)

		escribir(output,lugar,"Long_Vowel",list(set(vocales) & set(vocales_largas)),prefijo,postfijo)
		escribir(output,lugar,"Short_Vowel",list(set(vocales) & set(vocales_cortas)),prefijo,postfijo)
		escribir(output,lugar,"Dipthong_Vowel",list(set(vocales) & set(dipthongos)),prefijo,postfijo)
		
		#no estoy seguro de como clasificar estas
		#escribir(output,lugar,"Front_Start_Vowel",?,prefijo,postfijo)
		#escribir(output,lugar,"Back_Vowel",?,prefijo,postfijo)

		escribir(output,lugar,"High_Vowel",high_height_vowel,prefijo,postfijo)
		escribir(output,lugar,"Medium_Vowel",mid_height_vowel,prefijo,postfijo)
		escribir(output,lugar,"Low_Vowel",low_height_vowel,prefijo,postfijo)


		escribir(output,lugar,"Rounded_Vowel",list(set(vocales) & set(lip_plus)),prefijo,postfijo)
		escribir(output,lugar,"Unrounded_Vowel",list(set(vocales) & set(lip_minus)),prefijo,postfijo)
		escribir(output,lugar,"Reduced_Vowel",list(set(vocales) & set(front_frontness_vowel)),prefijo,postfijo)
		

		escribir(output,lugar,"Unvoiced_Consonant",consonant_minus,prefijo,postfijo)
		escribir(output,lugar,"Voiced_Consonant",consonant_plus,prefijo,postfijo)
		#No encontre regla, uso lo que estaba en preguntas en ingles, posiblemente contengan fonemas que no existan y falten alguns
		escribir(output,lugar,"Front_Consonant",labial + labioDental ,prefijo,postfijo)
		escribir(output,lugar,"Central_Consonant",alveolar + dental + paletal ,prefijo,postfijo)
		escribir(output,lugar,"Back_Consonant", velar ,prefijo,postfijo)

		escribir(output,lugar,"Labial",labial,prefijo,postfijo)
		escribir(output,lugar,"Alveolar",alveolar,prefijo,postfijo)
		escribir(output,lugar,"Velar", velar ,prefijo,postfijo)
		escribir(output,lugar,"Paletal", paletal ,prefijo,postfijo)
		escribir(output,lugar,"Labio-Dental", labioDental ,prefijo,postfijo)
		escribir(output,lugar,"Dental", dental ,prefijo,postfijo)

		escribir(output,lugar,"Unvoiced_Fricative",list(set(consonant_minus) & set(fricative)),prefijo,postfijo)
		#no existen fricativas voiced, esto no es necesario
		#escribir(output,lugar,"Voiced_Fricative",list(set(consonant_plus) & set(fricative)),prefijo,postfijo)

		for fonema in all_:
			escribir(output,lugar,fonema,[fonema],prefijo,postfijo)
		
		#Reglas no automaticas, corregir cuando sea necesario
		escribir(output,lugar,"IVowel",["i", "i1", "i0"],prefijo,postfijo)
		escribir(output,lugar,"UVowel",["u", "u1", "u0"],prefijo,postfijo)
		escribir(output,lugar,"AVowel",["a", "a1"],prefijo,postfijo)
		escribir(output,lugar,"EVowel",["e", "e1"],prefijo,postfijo)
		escribir(output,lugar,"OVowel",["o", "o1"],prefijo,postfijo)

		escribir(output,lugar,"Silence",["#"],prefijo,postfijo)

		escribir(output,lugar,"Reduced_Vowels_1",["i1","u1","a1","e1","o1"],prefijo,postfijo) #vocales reducidas: suenan menos fuerte
		escribir(output,lugar,"Reduced_Vowels_0",["i0","u0"],prefijo,postfijo) #vocales reducidas en diptongos

		escribir(output,lugar,"Fortis_Consonant", ["ch", "f", "k", "p","s","t","th", "rr","ll"] ,prefijo,postfijo)
		escribir(output,lugar,"Lenis_Consonant", ["b","d","g","x"] ,prefijo,postfijo)
		escribir(output,lugar,"Neigther_F_or_L", ["ny","hh","l","m","n","r"] ,prefijo,postfijo)
		
		escribir(output,lugar,"Unvoiced_Stop", ["p","k","t"] ,prefijo,postfijo)
		escribir(output,lugar,"Front_Stop", ["b", "p"] ,prefijo,postfijo)
		escribir(output,lugar,"Central_Stop", ["d", "t"] ,prefijo,postfijo)
		escribir(output,lugar,"Back_Stop", ["k", "g"] ,prefijo,postfijo)
		output.write("\n")




def escribir(file,lugar,nombre,rtas, prefix, postfix):


	aux = []
	for rta in rtas:
		aux.append(prefix + rta)

	final = []
	for rta in aux:
		final.append(rta + postfix)

	rta = [] #escribir prefijo y postfijo para cada rta
	file.write("QS \"" + lugar + "-" + nombre + "\"\t{"+ ",".join(final) + "}\n")

main()