#!/bin/sh

export PYTHONPATH=$PYTHONPATH:/home/newsreader/opt/lib/python2.6/
rootDir=/home/newsreader/components/VUA-svm-wsd

cd ${rootDir}
date +'Timestamp VUA-svm-wsd start command: %s%3N' 1>&2
python ${rootDir}/dsc_wsd_tagger-instrumented.py --naf 
date +'Timestamp VUA-svm-wsd end command: %s%3N' 1>&2

