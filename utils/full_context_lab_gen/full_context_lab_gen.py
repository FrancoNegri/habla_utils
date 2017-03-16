#!/usr/bin/python
#Transforms to lab format
import sys
import re

def syylable_counter(times,syllables_times):
    pos_foward = []
    currentIndex = -1
    counter=0
    for time in times:
        match=False
        for index in range(0,len(syllables_times)-1):
            if float(time) >= float(syllables_times[index]) and float(time) < float(syllables_times[index+1]):
                match=True
                if index == currentIndex:
                    counter+=1
                    pos_foward.append(counter)
                    break
                else:
                    counter=1
                    pos_foward.append(counter)
                    currentIndex = index
                    break
        if not match:
            print "any match on:", time
            counter=1
            currentIndex = -1
            pos_foward.append(counter)
    return pos_foward

def main():
    usage = 'Usage: ./lab_to_textgrid.py file'
    if len(sys.argv) != 2:
        print usage
        exit()
    ifname = sys.argv[1]
    fon = open(ifname+".fon",'r')
    or2 = open(ifname+".or2",'r')
    lab = open(ifname+".lab", 'w')
    # start getting the phones
    start_parsing = False
    phones = ["x","x","#"]
    times = ["0","0","0"]
    for line in fon:
        if not re.search('^\s*Tiempo\s*Color\s*Label', line) and not start_parsing:
            continue
        else:
            if not start_parsing:
                start_parsing = True
                continue
        tokens = line.split()
        time = tokens[0].strip()
        label = tokens[2].strip()
        phones.append(label)
        times.append(time)
    phones.append("x")
    phones.append("x")
    #TODO how to find end of audio?
    times.append("99")

    # now get the syllables
    syllables = []
    syllables_times = []
    start_parsing = False
    for line in or2:
        if not re.search('^#', line) and not start_parsing:
            continue
        else:
            if not start_parsing:
                start_parsing = True
                continue
        tokens = line.split()
        time = tokens[0].strip()
        syllable = tokens[2].strip()
        syllables.append(syllable)
        syllables_times.append(time)
    syllables_times.append(1000)

    # #Count silabbles foward
    pos_foward = syylable_counter(times,syllables_times)
    #TODO: fix this one
    pos_backwards = syylable_counter(reversed(times),syllables_times)

    #write all in lab format
    width = 8
    for i in range(2,len(phones)-2):
        #write times
        lab.write("  "+ times[i].ljust(width," ") + "  " + times[i+1].ljust(width," ") + " ")
        #write phones
        lab.write(phones[i-2]+"^"+phones[i-1]+"-"+phones[i]+"+"+phones[i+1]+"="+phones[i+2])
        #write position of the current phoneme identity in the current syllable forward then backwards
        lab.write("@"+str(pos_foward[i])+"_"+str(pos_backwards[i])+"\n")
    fon.close()
    lab.close()

if __name__ == "__main__":
    main()