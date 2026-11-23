#!/bin/bash

## Converts the downloaded xml data into a tsv format, keeping only PMID and abstracts.
##
## Input: PUBDATEGR variable
## Requires: data/raw/pubmed_data_PUBDATEGR.xml
## Creates: data/clean/abstracts_PUBDATEGR.tsv

PUBDATEGR=$1

# Time how long script takes to run
SECONDS=0

{
    # Create header
    printf "PMID|Abstract\n"

    # Extract PMID and abstracts, seperating multiple lines of abstracts with a space
    # PMID and Abstract are seperated with a |
    xtract -input data/raw/pubmed_data_${PUBDATEGR}.xml \
        -pattern PubmedArticle \
        -def "NA" \
        -tab "|" \
        -sep " " \
        -element MedlineCitation/PMID \
        -element Abstract/AbstractText
           
} > data/clean/abstracts_${PUBDATEGR}.tsv

# Print for logs
echo "xml to tsv conversion complete."
echo "Publishing date group: ${PUBDATEGR}"
echo "Run time: ${SECONDS}s"