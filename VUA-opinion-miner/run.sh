#!/bin/sh

export PYTHONPATH=$PYTHONPATH:/home/newsreader/opt/lib/python2.6/
rootDir=/home/newsreader/components/VUA-opinion-miner/opinion_miner_deluxe

cd ${rootDir}
python ${rootDir}/classify_kaf_file.py ${rootDir}/my_train.cfg #2> /dev/null
