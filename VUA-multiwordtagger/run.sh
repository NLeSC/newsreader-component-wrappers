#### Multiwordtagger using wordnet-lmf as a resource
cd /home/newsreader/components/VUA-multiwordtagger
date +'Timestamp VUA-multiwordtagger start command: %s%3N' 1>&2
java -Xmx812m -cp "./lib/KafMultiWordTagger-0.0.1-instrumented-jar-with-dependencies.jar" eu.kyotoproject.multiwordtagger.MultiTaggerSingleNaf --conf-file "./conf/mwtagger.cfg"
date +'Timestamp VUA-multiwordtagger end command: %s%3N' 1>&2
