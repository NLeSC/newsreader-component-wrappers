#### Multiwordtagger using wordnet-lmf as a resource
cd /home/newsreader/components/VUA-multiwordtagger
java -Xmx812m -cp "./lib/KafMultiWordTagger-0.0.1-jar-with-dependencies.jar" eu.kyotoproject.multiwordtagger.MultiTaggerSingleNaf --conf-file "./conf/mwtagger.cfg"
