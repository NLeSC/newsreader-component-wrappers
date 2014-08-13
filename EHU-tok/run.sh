#!/bin/bash

rootDir=/home/newsreader/components_source/ixa-pipe-tok/target
date +'EHU-tok start command: %s%3N' 1>&2
java -jar ${rootDir}/ixa-pipe-tok-1.5.1-timed.jar tok -l en --inputkaf
date +'EHU-tok end command: %s%3N' 1>&2


