#!/bin/bash

## Download data from PubMed 

# Search PubMed for articles that include "antimicrobial resistance" in the title
# then save as an xml file
esearch -db pubmed -query "antimicrobial resistance"[Title] |
efetch -format xml > data/raw/antimicrobial_resistance.xml

echo "search complete"