#!/bin/bash

rootDir=/home/newsreader/components/EHU-tok
date +'Timestamp EHU-tok start command: %s%3N' 1>&2
java -jar ${rootDir}/ixa-pipe-tok-1.5.1-timed.jar tok -l en --inputkaf
date +'Timestamp EHU-tok end command: %s%3N' 1>&2


