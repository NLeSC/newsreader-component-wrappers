#!/bin/bash

rootDir=/home/newsreader/components/EHU-nerc
date +'Timestamp EHU-nerc start command: %s%3N' 1>&2
java -jar ${rootDir}/ixa.pipe.nerc-1.0.0-timed.jar tag -f baseline --model /en/en-nerc-perceptron-baseline-c0-b3-ontonotes-4.0.bin
date +'Timestamp EHU-nerc end command: %s%3N' 1>&2
