#!/bin/bash

## Download article data from PubMed 
##
## Output: data/raw/pubmed_data.xml

decade="2010s"
start_date=2010
end_date=2012

# Time how long script takes to run
SECONDS=0

# Search PubMed for articles that include "antimicrobial resistance" in the title
# then save as an xml file Drug Resistance, Microbial [MeSH Terms] OR
esearch -db pubmed -query "$start_date:$end_date [PDAT] AND (antimicrobial resistance [TITL] OR amr [TITL] OR antibiotic resistance [TITL])" |
efetch -format xml > data/raw/pubmed_data_${decade}.xml

echo "Search complete."
echo "Decade: ${decade}"
echo "Number of articles extracted: $(grep "<PubmedArticle>" data/raw/pubmed_data_${decade}.xml | wc -l)"
echo "Run time: ${SECONDS}s"