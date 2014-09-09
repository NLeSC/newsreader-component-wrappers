#!/bin/bash

rootDir=/home/newsreader/components/EHU-pos
date +'Timestamp EHU-pos start command: %s%3N' 1>&2
java -jar ${rootDir}/ixa-pipe-pos-1.2.0-timed.jar tag
date +'Timestamp EHU-pos end command: %s%3N' 1>&2
