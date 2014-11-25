#### Within document event coreference baseline (lemma matches)
rootDir=/home/newsreader/components/VUA-eventcoref/
date +'Timestamp VUA-eventcoref start command: %s%3N' 1>&2
java -Xmx812m -cp "$rootDir/lib/EventCoreference-1.0-SNAPSHOT-instrumented-jar-with-dependencies.jar" eu.newsreader.eventcoreference.naf.EventCorefLemmaBaseline
date +'Timestamp VUA-eventcoref end command: %s%3N' 1>&2
