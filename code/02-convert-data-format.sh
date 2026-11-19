#!/bin/bash

## Converts the downloaded xml data into a tsv format, keeping only relevent elements.
##
## Requires: data/raw/antimicrobial_resistance.xml
## Creates: data/clean/antimicrobial_resistance.tsv

# Input the xml file of articles
# say it is a PUbMed article format
# extract specific elements
# Year completed must be added seperatedly because there are two "year"s, one for DataCompleted and one for DateRevised
# save as a file
{
    # Create header
    printf "PMID\tTitle\tAbstract\tJournal\tYearPublished\n"

    xtract -input data/raw/antimicrobial_resistance.xml \
        -pattern PubmedArticle \
        -element PMID ArticleTitle AbstractText Title\
        -block PubDate -element Year

} > data/clean/antimicrobial_resistance.tsv

echo "xml to tsv conversion complete"