#!/bin/bash

## Converts the downloaded xml data into a tsv format, keeping only relevent elements.
##
## Input:
## - PUBDATEGR variable
## Requires: 
##  - data/raw/pubmed_data.xml
## Creates: 
##  - data/clean/abstracts.tsv

PUBDATEGR=$1

# Time how long script takes to run
SECONDS=0

# Input the xml file of articles
# say it is a PUbMed article format
# extract specific elements
# save as a file


# Abstracts are extracted seperately due to formating issues. 
# A single column tsv is created, containing both PMID and the abstract text.

{
    # Create header
    printf "PMID|Abstract\n"

    xtract -input data/raw/pubmed_data_${PUBDATEGR}.xml \
        -pattern PubmedArticle \
        -def "NA" \
        -tab "|" \
        -sep " " \
        -element MedlineCitation/PMID \
        -element Abstract/AbstractText
           
} > data/clean/abstracts_${PUBDATEGR}.tsv


echo "xml to tsv conversion complete."
echo "Publishing date group: ${PUBDATEGR}"
echo "Run time: ${SECONDS}s"