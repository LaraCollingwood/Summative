#!/bin/bash

## Download article data from PubMed 
##
## Input: PUBDATEGR variable
## Output: data/raw/pubmed_data.xml

PUBDATEGR=$1
start_date=${PUBDATEGR}
end_date=$((start_date + 4)) ### CHANGE THIS

# Time how long script takes to run
SECONDS=0

# Search PubMed for articles that include "antimicrobial resistance" in the titleOR antimicrobial resistance [TITL] OR amr [TITL] OR antibiotic resistance [TITL])" 
# then save as an xml file 
esearch -db pubmed -query "$start_date:$end_date [PDAT] \
AND hasabstract \
AND (escherichia [TITL] OR coli [TITL]) \
AND (antimicrobial resistance [TITL] OR amr [TITL] OR antibiotic resistance [TITL] OR antimicrobial-resistant [TITL] OR antibiotic-resistant [TITL])" |
efetch -format xml > data/raw/pubmed_data_${PUBDATEGR}.xml

echo "Search complete."
echo "Publishing date group: ${PUBDATEGR}"
echo "Number of articles extracted: $(grep "<PubmedArticle>" data/raw/pubmed_data_${PUBDATEGR}.xml | wc -l)"
echo "Run time: ${SECONDS}s"