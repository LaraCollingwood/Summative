#!/bin/bash

#SBATCH --job-name=download_data
#SBATCH --partition=teach_cpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=10:00:0
#SBATCH --mem=1G
#SBATCH --account=SSCM040064

# run download files job
date
bash code/01-download-data.sh
date