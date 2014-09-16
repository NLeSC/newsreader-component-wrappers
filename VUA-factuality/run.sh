#!/bin/bash
# Two arguments by default:
# $1 = component directory
# $2 = scratch directory
compDir=$1
scratchDir=$2

rootDir=$compDir

# use non standard location for perl libraries
export PERL5LIB=$PERL5LIB:"$rootDir"/opt/lib/perl5

cd ${rootDir}
# Create a begin timestamp so we can log how long it takes to process a file
perl beginTimestamp.pl $scratchDir/begintimestamp.txt

# Convert NAF file to Mallet input file 
perl NAFToMalletInputFactuality.pl $scratchDir/temp.naf > $scratchDir/malletinput.tab

# Run the mallet classifier 
mallet-2.0.7/bin/csv2classify --input $scratchDir/malletinput.tab --output $scratchDir/malletoutput.txt --classifier MyMaxEntFactuality.classifier

# Sort the output in order to be able to select the best prediction and its confidence
perl sortMalletOutput.pl $scratchDir/malletoutput.txt > $scratchDir/malletoutput.sorted

# Write back to NAF 
perl convertMalletToNAF.pl $scratchDir/temp.naf $scratchDir/malletoutput.sorted $scratchDir/begintimestamp.txt

# Clean up
rm $scratchDir/temp.naf $scratchDir/malletinput.tab $scratchDir/malletoutput.txt $scratchDir/malletoutput.sorted $scratchDir/begintimestamp.txt
