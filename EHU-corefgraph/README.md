*CorefGraph is an independent module to perform coreference resolution*. View as
a NLP task which consists of determining the mentions that refer to the same 
entity in a text or discourse. CorefGraph is a python reimplementation of the 
[Stanford Multi Sieve Pass system (Lee et al., 2013)](http://www-nlp.stanford.edu/downloads/dcoref.shtml).

The module provides resources for English and Spanish coreference resolution but
it can be adapted to other languages. 

CorefGraph is part of the [IXA pipeline](https://github.com/ixa-ehu "IXA Pipeline Homepage") which can 
be used to provide the necessary input. 

This work has been partially funded by a *PhD Grant of the University of Deusto*. 

# How to install

## The Easy Ride: pip installation

PIP can install the module and every dependency in one command. It can be 
installed globally or at a user level.

* Globally (requires sudo privileges in linux systems):

        sudo pip install hg+https://bitbucket.org/Josu/corefgraph#egg=corefgraph

    The module can be updated to the newest version with: 
         
        sudo pip install -U hg+https://bitbucket.org/Josu/corefgraph#egg=corefgraph


* User available (is installed in the user disk space and only available to him)

        pip install --user hg+https://bitbucket.org/Josu/corefgraph#egg=corefgraph

    The module can be updated to the newest version with: 
         
        pip install --user -U hg+https://bitbucket.org/Josu/corefgraph#egg=corefgraph

## Long way: repository installation

For more control the module can be directly downloaded and copied into the file system.

    hg clone https://bitbucket.org/Josu/corefgraph
    cp corefgraph/corefgraph /usr/local/lib/python2.7/dist-packages/

To update the module use:

    hg update
    cp corefgraph/corefgraph /usr/local/lib/python2.7/dist-packages/

####Install dependencies

In order to use corefgraph, some dependencies are needed:

* pyKAF:

        hg clone https://bitbucket.org/Josu/pyKAF#egg=pyKAF
        cp pyKAF/pyKAF /usr/local/lib/python2.7/dist-packages/

    To update the dependency use:

        hg update
        cp pyKAF/pyKAF /usr/local/lib/python2.7/dist-packages/

* pycorpus:

        hg clone https://bitbucket.org/Josu/pyCorpus#egg=pyCorpus
        cp pyCorpus/pyCorpus /usr/local/lib/python2.7/dist-packages/

    To update the dependency use:

        hg update
        cp pyCorpus/pyCorpus /usr/local/lib/python2.7/dist-packages/

* networkx:
   *We recommend install networkx with PIP*

        pip install networkx

    or

        pip install --user networkx
    
    To update the dependency use:
    
        pip install -U networkx
    or
        
        pip install --U -user networkx
    
    For more installation instructions, please visit its [home page](http://networkx.github.io/documentation/latest/install.html)

* pyYALM:

    While install pyYAML is recommended, which is used in logging, this is not 
    compulsory. 

    *We recommend install pyYAML with pip*.

        pip install --user pyYAML

    or 

        sudo pip install pyYAML

    To update the dependency use:
        
        pip install -U pyYAML

    or

        pip install --U -user pyYAML

    For more installation instructions, please visit its [home page]( <https://bitbucket.org/xi/pyyaml>).

# Usage

This module may be used to process single files or directories (corpus). CorefGraph 
takes KAF or NAF documents as input. The input KAF/NAF documents must contain: 

+ Tokenized text
+ Part of Speech tags and Lemmas
+ Named Entities
+ Constituent Parsing with headwords for each constituent marked. 

The KAF specification is available [here](https://github.com/opener-project/kaf/wiki/KAF-structure-overview "KAF Homepage").

The NAF specification can be found [here](https://github.com/ixa-ehu/naf "NAF Homepage")

We recommend using the tools in the [IXA pipeline](https://github.com/opener-project/ixa-ehu "IXA Pipeline Homepage") 
to obtain the necessary linguistic annotation in a easy and efficient manner. 

## Single file

The most simple way to use this module is this:

    python -m corefgraph.process.file --file your_file.KAF --language es

This sentence outputs a KAF file containing all the original file info plus the 
coreference clusters.

The module is usable as a pipe:

    cat your_file.cat | python -m corefgraph.process.file --language es > output.KAF

#### Options

The system comes with a lot of options. There are grouped an described for 
review. Use *--help* parameter for the default and possible values.

**Input file related**

    --file -f The name of the file to process.
    
    --treebank (Optional) A file with the treebanks of the file. 
               If provided the syntactic info in the KAF is ignored.
    --speakers (Optional) A file containing the speakers of the text. 
               One line per word, sentences separated by blank lines, no speaker 
               is marked with '-'.
    --reader   (Optional) Switch into different input formats. For the moment only
               NAF and KAF.

**Algorithm related:**

    --language          Select the language resources to use; 'es' and 'en' are 
                        included so far.
    --sieves            (Optional) The plain name of the sieves that must be use
                        by the module.
    --sieves_options    (Optional) The options passed (as keywords) to 
                        the sieves.
    --extractor_options (Optional) The options used during the mention extraction.
    
    --singleton         (Optional) No filter the singleton mentions from results.

**Output:**

* General:

        --encoding    (Optional) Set the encoding of the output file; By default utf-8.

* ConLL related:

        --conll       (Optional) Output the result in ConLL format instead of KAF.
        
        --document_id (Optional) The document ID used in ConLL format.
        
        --part_id     (Optional) The part ID used in multiple part ConLL files.

* KAF/NAF related:

        --linguisticParserName    (Optional) The parser name printed in KAF 
                                  metadata.
        --linguisticParserVersion (Optional) The parser version printed in KAF 
                                  metadata.
        --linguisticParserLayer   (Optional) The parser layer printed in KAF 
                                  metadata.
        --time_stamp              (Optional) The TIMESTAMP printed in KAF 
                                  metadata.

**Other:**

    --verbose (Optional) Print more output while processing.
    
    --help (Optional) Show corefgraph help

## Multiple files

Multiple files mode, or corpus mode, can process multiple files concurrently. 
This mode is only usable in linux environments.

To use this mode first write a file that sets the parameters to process the 
files, and then use a command like this:

    python -m corefgraph.process.corpus --directories /home/KAF_dir -config configfile

#### Parameters
The multi file processor needs two basic parameters: a list of files and/or a list 
of input directories, plus a list of configuration files. Both lists should 
at least contain one element, otherwise the processing will end with empty
results. 

**Input files**

    --files       (Optional) List of files to process (if a directory is specified
                  these are added to the list.
    --directories (Optional) Recursive files of the directories.

    --extension   (Optional) File extension (without dot) that must be
                  processed. This option only works with --directories. Use '*' t
                  to process every extension. This options defaults to 'txt'.

**Configuration**

    --config The config file name. May be multiple files separated by ':' .
    
    --extra  (Optional) A common config for all config files. May be multiple 
             files separated by ':'.

**Evaluation**

    --evaluate (Optional) Activates the evaluation.
    
    --report   (Optional) Activates report system.

#### Config file

The config file uses the same parameters as in the single file usage mode plus 
the following:

**Additional parameters**

Output file related

    --result             (Optional) The extension of the result file. The 
                         file is stored next to the original file with
                         the same base name. 
    --speaker_extension  (Optional) If set, the module searches for a file with 
                         the same base name plus the extension and uses
                         it as speaker file. 
                         This option is switched off by default.  
    --treebank_extension (Optional) If set, the module searches for a file with 
                         the same base name plus the extension and uses it
                         as treebank file. This is used when the input KAF does 
                         not contain the constituent parsing layer. 
                         This option is switched off by default.

Evaluation parameters

    --metrics           (Optional) When the evaluation parameter is on, 
                        it is possible to specify the evaluation metric used.
    --output_eval_name  (Optional) When the evaluation parameter is on, 
                        it completes the results file name.
    --evaluation_script (Optional) When the evaluation parameter is on, 
                        it determines the script used to evaluate.
    --gold              (Optional) When the evaluation parameter is on, 
                        it determines where to find the gold standard corpus.

The following parameters are NOT AVAILABLE for its use in the configuration file:

**Forbidden parameters**

    --file
    
    --treebank
    
    --speakers

When using the --conll parameter, the conll document name and part must be 
provided using this pattern: *document_id#document_part.kaf*

So these parametters are disabled:

    --document_id
    
    --part_id

# Troubleshooting

* Make sure you have *python 2.7.1 or higher*.

        python --version

* If you have *problems using the --user option* you may consider to *update pip*.

        sudo pip install --upgrade pip

* The python dist-package directory might be in diferent location than:
       
        /usr/local/lib/python2.7/dist-packages/

#Contact information

    Josu Bermúdez
    DeustoTech 
    University of Deusto
    Bilbao
    josu.bermudez at deusto.es

    Rodrigo Agerri
    IXA NLP Group
    University of the Basque Country (UPV/EHU)
    E-20018 Donostia-San Sebastián
    rodrigo.agerri at ehu.es
