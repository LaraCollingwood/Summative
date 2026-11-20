#!/bin/bash

## Download article data from PubMed 
##
## Output: data/raw/antimicrobial_resistance.xml

# Time how long script takes to run
SECONDS=0

# Search PubMed for articles that include "antimicrobial resistance" in the title
# then save as an xml file
esearch -db pubmed -query "antimicrobial resistance"[Title] |
efetch -format xml > data/raw/antimicrobial_resistance.xml

echo "Search complete."
echo "Number of articles extracted: $(grep "<PubmedArticle>" data/raw/antimicrobial_resistance.xml | wc -l)"
echo "Run time: ${SECONDS}s"