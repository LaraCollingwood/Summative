#!/bin/bash

## Download data from PubMed

esearch -db pubmed -query "antimicrobial resistance"[Title] |
efetch -format xml > data/raw/antimicrobial_resistance.xml

echo "search complete"