#!/bin/bash

## Converts the downloaded xml data into a tsv format, keeping only relevent elements.
##
## Input:
## - PUBDATEGR variable
## Requires: 
##  - data/raw/pubmed_data.xml
## Creates: 
##  - data/clean/pubmed_data_no_abstract.tsv
##  - data/clean/abstracts.tsv

PUBDATEGR=$1

# Time how long script takes to run
SECONDS=0

# Input the xml file of articles
# say it is a PUbMed article format
# extract specific elements
# save as a file

{
    # Create header
    printf "PMID\tTitle\tJournal\tYearPublished\tPublicationType\n"

    xtract -input data/raw/pubmed_data_${PUBDATEGR}.xml \
        -pattern PubmedArticle \
        -def "NA" \
        -sep " "\
        -element  MedlineCitation/PMID \
        -element ArticleTitle \
        -element Journal/Title \
        -element PubDate/Year \
        -element PublicationType 

} > data/clean/pubmed_data_no_abstract_${PUBDATEGR}.tsv



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