#!/usr/bin/perl
#  ---------------------------------------------------------------  #
#           The HMM-Based Speech Synthesis System (HTS)             #
#                       HTS Working Group                           #
#                                                                   #
#                  Department of Computer Science                   #
#                  Nagoya Institute of Technology                   #
#                               and                                 #
#   Interdisciplinary Graduate School of Science and Engineering    #
#                  Tokyo Institute of Technology                    #
#                                                                   #
#                     Copyright (c) 2001-2008                       #
#                       All Rights Reserved.                        #
#                                                                   #
#  Permission is hereby granted, free of charge, to use and         #
#  distribute this software and its documentation without           #
#  restriction, including without limitation the rights to use,     #
#  copy, modify, merge, publish, distribute, sublicense, and/or     #
#  sell copies of this work, and to permit persons to whom this     #
#  work is furnished to do so, subject to the following conditions: #
#                                                                   #
#    1. The source code must retain the above copyright notice,     #
#       this list of conditions and the following disclaimer.       #
#                                                                   #
#    2. Any modifications to the source code must be clearly        #
#       marked as such.                                             #
#                                                                   #
#    3. Redistributions in binary form must reproduce the above     #
#       copyright notice, this list of conditions and the           #
#       following disclaimer in the documentation and/or other      #
#       materials provided with the distribution.  Otherwise, one   #
#       must contact the HTS working group.                         #
#                                                                   #
#  NAGOYA INSTITUTE OF TECHNOLOGY, TOKYO INSTITUTE OF TECHNOLOGY,   #
#  HTS WORKING GROUP, AND THE CONTRIBUTORS TO THIS WORK DISCLAIM    #
#  ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL       #
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT   #
#  SHALL NAGOYA INSTITUTE OF TECHNOLOGY, TOKYO INSTITUTE OF         #
#  TECHNOLOGY, HTS WORKING GROUP, NOR THE CONTRIBUTORS BE LIABLE    #
#  FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY        #
#  DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,  #
#  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTUOUS   #
#  ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR          #
#  PERFORMANCE OF THIS SOFTWARE.                                    #
#                                                                   #
#  ---------------------------------------------------------------  #

$|=1;

use File::Basename;

$nARGV = @ARGV;
if ($nARGV<2 || $nARGV>2) {
   print "inf2dot.pl : convert HTK decision tree format into graphviz format \n";
   print "           usage : inf2dot.pl infile outfile                       \n";
   exit(0);
}

if ($ARGV[1] =~ /-/) {
   print "inf2dot.pl : sorry, name of outfile cannot contain \"-\" \n";
   exit(1);
}

open(IN, $ARGV[0]) || die "inf2dot.pl : cannot open file : $ARGV[0]";

while(<IN>) {
   $line = $_;
   chomp($line);
   
   if ($line =~ /^.*\[[0-9]*\]/) {
      $line =~ s/\[//g;
      $line =~ s/\]//g;
      $line =~ s/\.//g;
      $line =~ s/\,//g; 
      open(OUT,">$ARGV[1]_$line.dot") || die "inf2dot.pl : cannot open output file : $ARGV[1]_$line.dot";
      $graphname = basename($ARGV[1]);
      print OUT "digraph ${graphname}_$line {\n";
   }
   elsif ($line =~ /\}/) {
      print OUT "}\n";
      close(OUT);
   }
   elsif ($line ne "" && $line !~ /QS / && $line !~ /\{/ && $line !~ /\}/ && $line !~ /\[/ ) {
      @LINE = split(' ',$line);
      
      # print current node
      print OUT "   $LINE[0]  \[label=\"$LINE[1]\" ";
      if ($LINE[1] =~ /[ABCDE]\_[0-9]*/) {
         print OUT ", style=filled, fillcolor=gray";
      }
      print OUT "\]\;\n";

      # print no arc
      if ($LINE[2] =~ /[a-zA-Z]/) {
         print OUT "   $LINE[2]  \[shape=box,style=filled,fillcolor=gold]\;\n";
      }
      print OUT "   $LINE[0]  -\> $LINE[2] \[label=\"no\",color=red\];\n";

      # print yes arc
      if ($LINE[3] =~ /[a-zA-Z]/) {
         print OUT "   $LINE[3]  \[shape=box,style=filled,fillcolor=gold]\;\n";
      }
      print OUT "   $LINE[0]  -\> $LINE[3] \[label=\"yes\",color=blue\]\;\n";
   }
}

close(IN);
