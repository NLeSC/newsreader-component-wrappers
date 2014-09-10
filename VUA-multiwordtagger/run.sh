#### Multiwordtagger using wordnet-lmf as a resource
cd /home/newsreader/components/VUA-multiwordtagger
date +'Timestamp VUA-mw start command: %s%3N' 1>&2
java -Xmx812m -cp "./lib/KafMultiWordTagger-0.0.1-jar-with-dependencies.jar" eu.kyotoproject.multiwordtagger.MultiTaggerSingleNaf --conf-file "./conf/mwtagger.cfg"
date +'Timestamp VUA-mw end command: %s%3N' 1>&2
