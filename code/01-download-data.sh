#!/bin/bash

## Download data from PubMed

esearch -db pubmed -query "antimicrobial resistance"[Title/Abstract] |
efetch -format xml > raw/antimicrobial_resistance.xml

echo "search complete"