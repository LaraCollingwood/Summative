#!/bin/bash

mkdir -p data/raw
mkdir -p data/clean
mkdir -p results


#bash code/01-download-data.sh
bash code/02-convert-data-format.sh
Rscript code/03-clean-data.R "2010s"
Rscript code/04-simple-process-data.R
Rscript code/05-simple-plot-data.R