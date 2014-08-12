#!/bin/bash

rootDir=/home/newsreader/components/EHU-ned


portInfo=$(nmap -p 2020 localhost | grep open)

if [ -z "$portInfo" ]
  then
    java -jar -Xmx4g ${rootDir}/dbpedia-jdbm/dbpedia-spotlight.jar ${rootDir}/dbpedia-jdbm/en http://localhost:2020/rest &
    sleep 180
fi

java -jar ${rootDir}/ixa-pipe-ned-1.0.jar -p 2020
