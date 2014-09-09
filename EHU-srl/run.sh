#!/bin/bash

rootDir=/home/newsreader/components/EHU-srl
date +'Timestamp EHU-srl start command: %s%3N' 1>&2
exec java -jar -Xms2500m ${rootDir}/IXA-EHU-srl-1.0-timed.jar en
date +'Timestamp EHU-srl end command: %s%3N' 1>&2
