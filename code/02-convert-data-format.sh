#!/bin/bash

## Converts the downloaded xml data into a tsv format, keeping only relevent elements.
##
## Requires: 
##  - data/raw/antimicrobial_resistance.xml
## Creates: 
##  - data/clean/antimicrobial_resistance_no_abstract.tsv
##  - data/clean/antimicrobial_resistance_abstract.tsv

# Time how long script takes to run
SECONDS=0

# Input the xml file of articles
# say it is a PUbMed article format
# extract specific elements
# save as a file

{
    # Create header
    printf "PMID\tTitle\tJournal\tYearPublished\tPublicationType\n"

    xtract -input data/raw/antimicrobial_resistance.xml \
        -pattern PubmedArticle \
        -def "NA" \
        -sep " "\
        -element  MedlineCitation/PMID \
        -element ArticleTitle \
        -element Journal/Title \
        -element PubDate/Year \
        -element PublicationType

} > data/clean/antimicrobial_resistance_no_abstract.tsv



# Abstracts are extracted seperately due to formating issues. 
# A single column tsv is created, containing both PMID and the abstract text.

{
    # Create header
    printf "PMID|Abstract\n"

    xtract -input data/raw/antimicrobial_resistance.xml \
        -pattern PubmedArticle \
        -def "NA" \
        -tab "|" \
        -sep " " \
        -element MedlineCitation/PMID \
        -element Abstract/AbstractText
           
} > data/clean/antimicrobial_resistance_abstract.tsv


echo "xml to tsv conversion complete."
echo "Run time: ${SECONDS}s"