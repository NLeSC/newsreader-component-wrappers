#!/bin/sh
cd /home/newsreader/components/FBK-time

BEGINTIME=`date '+%Y-%m-%dT%H:%M:%S%z'`
RANDOM=`bash -c 'echo $RANDOM'`

FILETXP=/tmp/$RANDOM-TimePro.txp
CHUNKIN=/tmp/$RANDOM-TimePro.naf
FILEOUT=/tmp/$RANDOM-TimeProOUT.txp
TIMEPRONORMIN=/tmp/$RANDOM-TimeProNormIN.txp

cat $1 > $CHUNKIN
cat $CHUNKIN | python from_CT_to_chunks.py | $JAVA_HOME/bin/java -jar NAFtoTXP.jar $FILETXP chunk+entity 

#echo "Saving... $FILETXP"
tail -n +4 $FILETXP | awk -f english-rules > $FILEOUT
head -n +4 $FILETXP > $TIMEPRONORMIN

cat $FILEOUT | ./tools/yamcha-0.33/usr/local/bin/yamcha -m tempeval3_silver-data.model >> $TIMEPRONORMIN
cat $TIMEPRONORMIN | $JAVA_HOME/bin/java -jar lib/TimeProNorm.jar $FILETXP
#cat $FILEOUT | ./tools/yamcha-0.33/usr/local/bin/yamcha -m tempeval3_silver-data.model | $JAVA_HOME/bin/java -jar lib/TimeProNorm.jar $FILETXP

rm $FILEOUT
rm $TIMEPRONORMIN

#echo "TimeProNAF $CHUNKIN $FILETXP"

$JAVA_HOME/bin/java -Dfile.encoding=UTF8 -cp "lib/textpro-time.jar:lib/commons-io-2.4.jar:lib/jdom.jar:lib/junit-4.5.jar" eu.fbk.textpro.main.TimeProNAF $CHUNKIN $FILETXP false "$BEGINTIME" 
#$JAVA_HOME/bin/java -Dfile.encoding=UTF8 -cp "lib/textpro-time.jar:lib/commons-io-2.4.jar:lib/jdom.jar:lib/junit-4.5.jar" eu.fbk.textpro.main.TimeProNAFTester $CHUNKIN $FILETXP true

cat $FILETXP.out
rm $FILETXP
rm $FILETXP.out
rm $CHUNKIN

