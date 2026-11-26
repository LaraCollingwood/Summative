#!/bin/bash

## Downloads article data from PubMed and saves as an xml.
## The search criteria requires articles to be in the selected time frame, have an abstract, 
## mention AMR in the title and mention e. coli in the title.
##
## Input: PUBDATEGR variable
## Output: data/raw/pubmed_data_PUBDATGR.xml

PUBDATEGR=$1

# Time how long script takes to run
SECONDS=0

# Set variables for 
start_date=${PUBDATEGR}
end_date=$((start_date + 4))

# Search PubMed for relevant articles and save as an xml file 
esearch -db pubmed -query "$start_date:$end_date [PDAT] \
AND hasabstract \
AND (escherichia [TITL] OR coli [TITL]) \
AND (antimicrobial resistance [TITL] OR amr [TITL] OR antibiotic resistance [TITL] OR antimicrobial-resistant [TITL] OR antibiotic-resistant [TITL])" |
efetch -format xml > data/raw/pubmed_data_${PUBDATEGR}.xml

# Print for logs
echo "Search complete."
echo "Publishing date group: ${PUBDATEGR}"
echo "Number of articles extracted: $(grep "<PubmedArticle>" data/raw/pubmed_data_${PUBDATEGR}.xml | wc -l)"
echo "Run time: ${SECONDS}s"