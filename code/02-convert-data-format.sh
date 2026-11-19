#!/bin/bash

## Converts the downloaded xml data into a tsv format, keeping only relevent elements.
##
## Requires: data/raw/antimicrobial_resistance.xml
## Creates: data/clean/antimicrobial_resistance.tsv

# Input the xml file of articles
# say it is a PUbMed article format
# extract specific elements
# save as a file

xtract -input data/raw/antimicrobial_resistance.xml \
    -pattern PubmedArticle \
    -element PMID ArticleTitle AbstractText Title DateCompleted\
    > data/clean/antimicrobial_resistance.tsv

echo "xml to tsv conversion complete"