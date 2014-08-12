#!/bin/bash

rootDir=/home/newsreader/components/EHU-corefgraph
currentDir=$PWD

cd $rootDir
/home/newsreader/opt/bin/python -m corefgraph.process.file --reader NAF

