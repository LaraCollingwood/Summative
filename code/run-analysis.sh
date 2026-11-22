#!/bin/bash

#mkdir -p data/raw
#mkdir -p data/clean
#mkdir -p results

decade=1990s
bash code/01-download-data.sh ${decade}
bash code/02-convert-data-format.sh ${decade}
Rscript code/03-clean-data.R ${decade}
Rscript code/04-topic-modelling.R ${decade}
#Rscript code/04-simple-process-data.R
#Rscript code/05-simple-plot-data.R