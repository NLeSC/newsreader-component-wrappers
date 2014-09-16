#!/bin/bash
#rootDir=`pwd`
# Two arguments by default:
# $1 = component directory
# $2 = scratch directory
# Module specific:
# $3 = xml input file
compDir=$1
scratchDir=$2
xmlFile=$3

rootDir=$compDir
tmpDir=$scratchDir

cd "$rootDir"
BEGINTIME=`date '+%Y-%m-%dT%H:%M:%S%z'`
RANDOM=`bash -c 'echo $RANDOM'`

FILETXP="$tmpDir"/$RANDOM-TimePro.txp
CHUNKIN="$tmpDir"/$RANDOM-TimePro.naf
FILEOUT="$tmpDir"/$RANDOM-TimeProOUT.txp
TIMEPRONORMIN="$tmpDir"/$RANDOM-TimeProNormIN.txp
#echo $2 1>&2
#echo BOEBOEBOE: $CHUNKIN 1>&2
cat $xmlFile > $CHUNKIN 
cat $CHUNKIN | python from_CT_to_chunks.py | java -jar NAFtoTXP.jar $FILETXP chunk+entity 

#python from_CT_to_chunks.py | java -jar NAFtoTXP.jar $FILETXP chunk+entity 

#echo "Saving... $FILETXP"
tail -n +4 $FILETXP | awk -f english-rules > $FILEOUT
head -n +4 $FILETXP > $TIMEPRONORMIN

cat $FILEOUT | "$rootDir"/tools/yamcha-0.33/usr/local/bin/yamcha -m tempeval3_silver-data.model >> $TIMEPRONORMIN
cat $TIMEPRONORMIN | java -jar lib/TimeProNorm.jar $FILETXP
#cat $FILEOUT | "$rootDir"/tools/yamcha-0.33/usr/local/bin/yamcha -m tempeval3_silver-data.model | java -jar lib/TimeProNorm.jar $FILETXP

rm $FILEOUT
rm $TIMEPRONORMIN

#echo "TimeProNAF $CHUNKIN $FILETXP"

java -Dfile.encoding=UTF8 -cp "lib/textpro-time.jar:lib/commons-io-2.4.jar:lib/jdom.jar:lib/junit-4.5.jar" eu.fbk.textpro.main.TimeProNAF $CHUNKIN $FILETXP false "$BEGINTIME" &> /dev/null 
java -Dfile.encoding=UTF8 -cp "lib/textpro-time.jar:lib/commons-io-2.4.jar:lib/jdom.jar:lib/junit-4.5.jar" eu.fbk.textpro.main.TimeProNAFTester $CHUNKIN $FILETXP true &> /dev/null

cat $FILETXP.out
rm $FILETXP
rm $FILETXP.out
rm $CHUNKIN

