#!/bin/bash
# Two arguments always:
# $1 = component directory
# $2 = scratch directory
compDir=$1
scratchDir=$2

rootDir=$compDir
java -jar ${rootDir}/ixa-pipe-ned-1.0.jar -H http://dbpedia.sara.cloudlet.sara.nl -p 2020
