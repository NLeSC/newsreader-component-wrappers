#!/bin/bash

rootDir=/home/newsreader/components/EHU-ukb
${rootDir}/naf_ukb/naf_ukb.pl -x ${rootDir}/ukb/bin/ukb_wsd -K ${rootDir}/wn30_lkb/wn30g.bin64 -D ${rootDir}/wn30_lkb/wn30.lex - -- --dgraph_dfs --dgraph_rank ppr
