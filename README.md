# Overview

Welcome to my Advanced Health Data Science summative coursework! This project will explore research trends in antimicrobial resistance, by analysing data from PubMed and producing a data visualisation. It is intended to be ran on BluePebble.

Note: currently incomplete

# Running the project

## 1. Cloning the git repository

To clone the contents of this git repository, log into BluePebble, nagivate into your desired directory and run this command in terminal.

```
git clone https://github.com/LaraCollingwood/Summative.git
```

## 2. Activate the conda environment

Activate conda
```
source ~/initConda.sh
```

Nagivate into the Summative direcory using
```
cd Summative
```

To activate the environment, run this in terminal.
```
conda env create -f environment.yml
conda activate env_2872299
```

# 3. Run the SnakeMake pipeline

Run the SnakeMake pipeline with 
```
snakemake --profile .
```