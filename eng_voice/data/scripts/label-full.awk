# ----------------------------------------------------------------- #
#           The HMM-Based Speech Synthesis System (HTS)             #
#           developed by HTS Working Group                          #
#           http://hts.sp.nitech.ac.jp/                             #
# ----------------------------------------------------------------- #
#                                                                   #
#  Copyright (c) 2001-2015  Nagoya Institute of Technology          #
#                           Department of Computer Science          #
#                                                                   #
#                2001-2008  Tokyo Institute of Technology           #
#                           Interdisciplinary Graduate School of    #
#                           Science and Engineering                 #
#                                                                   #
# All rights reserved.                                              #
#                                                                   #
# Redistribution and use in source and binary forms, with or        #
# without modification, are permitted provided that the following   #
# conditions are met:                                               #
#                                                                   #
# - Redistributions of source code must retain the above copyright  #
#   notice, this list of conditions and the following disclaimer.   #
# - Redistributions in binary form must reproduce the above         #
#   copyright notice, this list of conditions and the following     #
#   disclaimer in the documentation and/or other materials provided #
#   with the distribution.                                          #
# - Neither the name of the HTS working group nor the names of its  #
#   contributors may be used to endorse or promote products derived #
#   from this software without specific prior written permission.   #
#                                                                   #
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND            #
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,       #
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF          #
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE          #
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS #
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,          #
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED   #
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,     #
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON #
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,   #
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY    #
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE           #
# POSSIBILITY OF SUCH DAMAGE.                                       #
# ----------------------------------------------------------------- #

{
##############################
###  SEGMENT

#  boundary
   printf "%10.0f %10.0f ", 1e7 * $65, 1e7 * $66

#  pp.name
    printf "%s",  ($63 == "0" || $63 == "#") ? (($63 == "0") ? "nil" : "sp" ): $63
#  p.name
    printf "^%s", ($1  == "0" || $1 == "#") ? (($1 == "0") ? "nil" : "sp" ) : $1
#  c.name
    printf "-%s", ($2 == "#") ? "sp" : $2
#  n.name
    printf "+%s", ($3  == "0"|| $3 == "#") ? (($3 == "0") ? "nil" : "sp" ) : $3
#  nn.name
    printf "=%s", ($64 == "0"|| $64 == "#") ? (($64 == "0") ? "nil" : "sp" ) : $64 

#  position in syllable (segment)
    printf "@"
    printf "%s",  ($2 == "pau") ? "nil" : $4 + 1
    printf "_%s", ($2 == "pau") ? "nil" : $12 - $4

##############################
###  SYLLABLE

## previous syllable

#  p.stress
    printf "/A:%s", ($2 == "pau") ? ($53==0?"nil":$49) : ($11==0?"nil":$5)
#  p.accent
    printf "_%s", ($2 == "pau") ? ($53==0?"nil":$51) : ($11==0?"nil":$8)
#  p.length
    printf "_%s", ($2 == "pau") ? ($53==0?"nil":$53) : ($11==0?"nil":$11)

## current syllable

#  c.stress
    printf "/B:%s", ($2 == "pau") ? "nil" : $6
#  c.accent
    printf "-%s", ($2 == "pau") ? "nil" : $9
#  c.length
    printf "-%s", ($2 == "pau") ? "nil" : $12

#  position in word (syllable)
    printf "@%s", ($2 == "pau") ? "nil" : $14 + 1
    printf "-%s", ($2 == "pau") ? "nil" : $30 - $14

#  position in phrase (syllable)
    printf "&%s", ($2 == "pau") ? "nil" : $15 + 1
    printf "-%s", ($2 == "pau") ? "nil" : $16 + 1

#  position in phrase (stressed syllable)
    printf "#%s", ($2 == "pau") ? "nil" : $17
    printf "-%s", ($2 == "pau") ? "nil" : $18

#  position in phrase (accented syllable)
    printf  "$"
    printf "%s", ($2 == "pau") ? "nil" : $19
    printf "-%s", ($2 == "pau") ? "nil" : $20

#  distance from stressed syllable
    printf "!%s", ($2 == "pau") ? "nil" : ($21==0?"nil":$21)
    printf "-%s", ($2 == "pau") ? "nil" : ($22==0?"nil":$22)

#  distance from accented syllable 
    printf ";%s", ($2 == "pau") ? "nil" : ($23==0?"nil":$23)
    printf "-%s", ($2 == "pau") ? "nil" : ($24==0?"nil":$24)

#  name of the vowel of current syllable
    printf "|%s", ($2 == "pau") ? "nil" : $25

## next syllable

#  n.stress
    printf "/C:%s", ($2 == "pau") ? ($54==0?"nil":$50) : ($13==0?"nil":$7)
#  n.accent
    printf "+%s", ($2 == "pau") ? ($54==0?"nil":$52) : ($13==0?"nil":$10)
#  n.length
    printf "+%s", ($2 == "pau") ? ($54==0?"nil":$54) : ($13==0?"nil":$13)

##############################
#  WORD

##################
## previous word

#  p.gpos
    printf "/D:%s", ($2 == "pau") ? ($57==0?"nil":$55) : ($29==0?"nil":$26)
#  p.length (syllable)
    printf "_%s", ($2 == "pau") ? ($57==0?"nil":$57) : ($29==0?"nil":$29)

#################
## current word

#  c.gpos
    printf "/E:%s", ($2 == "pau") ? "nil" : $27
#  c.length (syllable)
    printf "+%s", ($2 == "pau") ? "nil" : $30

#  position in phrase (word)
    printf "@%s", ($2 == "pau") ? "nil" : $32 + 1
    printf "+%s", ($2 == "pau") ? "nil" : $33

#  position in phrase (content word)
    printf "&%s", ($2 == "pau") ? "nil" : $34
    printf "+%s", ($2 == "pau") ? "nil" : $35

#  distance from content word in phrase
    printf "#%s", ($2 == "pau") ? "nil" : ($36==0?"nil":$36)
    printf "+%s", ($2 == "pau") ? "nil" : ($37==0?"nil":$37)

##############
## next word

#  n.gpos
    printf "/F:%s", ($2 == "pau") ? ($58==0?"nil":$56) : ($31==0?"nil":$28)
#  n.length (syllable)
    printf "_%s", ($2 == "pau") ? ($58==0?"nil":$58) : ($31==0?"nil":$31)

##############################
#  PHRASE

####################
## previous phrase

#  length of previous phrase (syllable)
    printf "/G:%s", ($2 == "pau") ? ($59==0?"nil":$59) : ($38==0?"nil":$38)

#  length of previous phrase (word)
    printf "_%s"  , ($2 == "pau") ? ($61==0?"nil":$61) : ($41==0?"nil":$41)

####################
## current phrase

#  length of current phrase (syllable)
    printf "/H:%s", ($2 == "pau") ? "nil" : $39

#  length of current phrase (word)
    printf "=%s",   ($2 == "pau") ? "nil" : $42

#  position in major phrase (phrase)
    printf "^";
    printf "%s",  ($2 == "pau") ? "nil" : $44 + 1
    printf "=%s", ($2 == "pau") ? "nil" : $48 - $44

#  type of tobi endtone of current phrase
    printf "|%s", ($2 == "pau") ? "nil" : $45

####################
## next phrase

#  length of next phrase (syllable)
    printf "/I:%s", ($2 == "pau") ? ($60==0?"nil":$60) : ($40==0?"nil":$40)

#  length of next phrase (word)
    printf "=%s",   ($2 == "pau") ? ($62==0?"nil":$62) : ($43==0?"nil":$43)

##############################
#  UTTERANCE

#  length (syllable)
    printf "/J:%s", $46

#  length (word)
    printf "+%s", $47

#  length (phrase)
    printf "-%s", $48

    printf "\n"
}
