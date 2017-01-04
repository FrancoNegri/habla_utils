Esto es un clon de HTS-demo_CMU-ARCTIC-SLT en donde:

/data/raw: archivos de audio en castellano (.raw)

/data/utt los archivos .utt generados anteriormente.

/data/labels/gen los archivos .lab que querremos sintetizar (acá es donde habría que sintetizar los .lab a partir de los .utt que generé, pero en el tutorial no es tan claro como hacerlo).

Al hacer make labels (dentro le la carpeta data) es donde me tira los:

Phone e not in phone set radio

Phone "j" not member of PhoneSet "radio"

Phone j not in phone set radio

Phone "j" not member of PhoneSet "radio"

Aunque ahora que me doy cuenta los .lab estaban mal (había puesto los utt en vez de los .lab).

Aun utilizando los .lab de la demo en ingles me sigue saltando el error el mismo error así que posiblemente las etiquetas de /data/utt esten mal generadas?

Notar que aunque lanza todos esos errores en las carpetas data/labels/mono y data/labels/full igual esta generando los .lab