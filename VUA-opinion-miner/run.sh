#!/bin/sh
# Two arguments by default:
# $1 = component directory
# $2 = scratch directory
compDir=$1
scratchDir=$2

WD=$compDir
rootDir="$WD"/opinion_miner_deluxe

export PYTHONPATH=$PYTHONPATH:"$WD"/opt/lib/python2.6/

cat "$rootDir"/my_train.cfg.template | sed -e 's|BASEDIR|'${WD}'|g' > "$scratchDir"/my_train.cfg

cd ${rootDir}
python ${rootDir}/classify_kaf_file.py ${scratchDir}/my_train.cfg #2> /dev/null

rm "$scratchDir"/my_train.cfg
