#!/bin/bash

date +'Timestamp VUA-factuality start command: %s%3N' 1>&2

# use non standard location for perl libraries
export PERL5LIB=$PERL5LIB:/home/newsreader/opt/lib/perl5
rootDir=/home/newsreader/components/VUA-factuality

cd ${rootDir}
# Create a begin timestamp so we can log how long it takes to process a file
perl beginTimestamp.pl

date +'Timestamp VUA-factuality start in-command: %s%3N' 1>&2

# Convert NAF file to Mallet input file 
perl NAFToMalletInputFactuality.pl > malletinput.tab

date +'Timestamp VUA-factuality start work: %s%3N' 1>&2

# Run the mallet classifier 
mallet-2.0.7/bin/csv2classify --input malletinput.tab --output malletoutput.txt --classifier MyMaxEntFactuality.classifier

date +'Timestamp VUA-factuality end work: %s%3N' 1>&2

# Sort the output in order to be able to select the best prediction and its confidence
perl sortMalletOutput.pl malletoutput.txt > malletoutput.sorted

date +'Timestamp VUA-factuality end in-command: %s%3N' 1>&2

# Write back to NAF 
perl convertMalletToNAF.pl temp.naf malletoutput.sorted

# Clean up
rm temp.naf malletinput.tab malletoutput.txt malletoutput.sorted begintimestamp.txt

date +'Timestamp VUA-factuality end command: %s%3N' 1>&2
