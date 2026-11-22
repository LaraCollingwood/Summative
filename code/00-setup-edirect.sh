#!/bin/bash

# Install Edirect software
sh -c "$(curl -fsSL https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"

export PATH=${HOME}/edirect:${PATH} 