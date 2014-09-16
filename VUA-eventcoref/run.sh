#!/bin/bash
# Two arguments by default:
# $1 = component directory
# $2 = scratch directory
compDir=$1
scratchDir=$2

rootDir=$compDir
java -Xmx812m -cp "$rootDir/lib/EventCoreference-1.0-SNAPSHOT-jar-with-dependencies.jar" eu.newsreader.eventcoreference.naf.EventCorefLemmaBaseline
