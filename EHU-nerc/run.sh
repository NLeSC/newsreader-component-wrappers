#!/bin/bash
# Two arguments by default:
# $1 = component directory
# $2 = scratch directory
compDir=$1
scratchDir=$2

rootDir=$compDir
java -jar ${rootDir}/ixa.pipe.nerc-1.0.0.jar tag -f baseline --model /en/en-nerc-perceptron-baseline-c0-b3-ontonotes-4.0.bin
