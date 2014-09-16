#!/bin/bash
# Two arguments by default:
# $1 = component directory
# $2 = scratch directory
compDir=$1
scratchDir=$2

rootDir=$compDir
java -jar -Xms4G -Xmx4G ${rootDir}/IXA-EHU-srl-1.0.jar en
