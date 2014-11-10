#!/bin/sh

export PYTHONPATH=$PYTHONPATH:/home/newsreader/opt/lib/python2.6/
rootDir=/home/newsreader/components/VUA-opinion-miner/opinion_miner_deluxe

cd ${rootDir}
date +'Timestamp VUA-opinion-miner start command: %s%3N' 1>&2
python ${rootDir}/classify_kaf_file.py ${rootDir}/my_train.cfg #2> /dev/null
date +'Timestamp VUA-opinion-miner end command: %s%3N' 1>&2
