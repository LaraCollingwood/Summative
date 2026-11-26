# Overview

Welcome to my Advanced Health Data Science summative coursework! This project will explore research trends in antimicrobial resistance (AMR) in E. coli, by analysing data from PubMed and producing a data visualisation. It is intended to be ran on BluePebble, but can be ran locally too.

# Background

The question being investigated is

> How has focus of research topics in antimicrobial resistance of E. coli changed from 1980 to 2024?

E. coli (Escherichia coli) is a bacteria found in the intestines of people and animals that can cause symptoms such as UTIs, diarrhea and vommitting. It is spread though contaminated water, undercooked food and contact with farm animals. A treatment for E. coli infection is antibiotics.  

However, some strains of the microbe have evolved to survive these medicines designed to kill them, making them very difficult to treat. This is known as antimicrobial resistance, or AMR. As we are referring to bacteria, it can also be called antibacterial resistance. 

This project aims to explore how the focus of research in this area has evolved in the past 45 years.

# Running the project

## 1. Cloning the git repository

To clone the contents of this git repository, log into BluePebble (optional), nagivate into your desired directory and run this command in terminal.

```
git clone https://github.com/LaraCollingwood/Summative.git
```

## 2. Activate the conda environment

You may need to activate conda first.
```
source ~/initConda.sh
```

Nagivate into the Summative directory using
```
cd Summative
```

and activate the environment, by running this in terminal.
```
conda env create -f environment.yml
conda activate env_2872299
```

## 3. Run the SnakeMake pipeline

If you are using BluePebble, run the SnakeMake pipeline with 
```
snakemake --profile .
```

If you are not using BluePebble and instead working locally, run the SnakeMake pipleline with 
```
snakemake -c1
```

# Code files

## 01-download-data.sh

Downloads article data from PubMed and saves as an xml. The search criteria requires articles to be in the selected time frame, have an abstract, mention AMR in the title and mention E. coli in the title.

- Input: PUBDATEGR variable
- Output: data/raw/pubmed_data_PUBDATGR.xml

To run independently, for a chosen timeframe (e.g. 1980-1984), input into terminal
```
bash code/01-download-data.sh 1980
```

## 02-convert-data-format.sh

Converts the downloaded xml data into a tsv format, keeping only PMID and abstracts.

- Input: PUBDATEGR variable
- Requires: data/raw/pubmed_data_PUBDATEGR.xml
- Creates: data/clean/abstracts_PUBDATEGR.tsv

To run independently, for a chosen timeframe (e.g. 1980-1984), input into terminal
```
bash code/02-convert-data-format.sh 1980
```

## 03-clean-data.R

Converts abstract data into word counts, removing numbers, stop words and pre-specified common words.

- Input: PUBDATEGR variable
- Requires: data/clean/abstracts_PUBDATEGR.tsv
- Creates: data/clean/word_count.tsv

To run independently, for a chosen timeframe (e.g. 1980-1984), input into terminal
```
Rscript code/03-clean-data.R 1980
```

## 04-topic-modelling.R

Uses Latent Dirichlet Allocation to pick out 6 key topics, then see how well the articles from each publishing data group fit into these topics. Also picks out the top words and top PMIDs from each topic.

- Requires: data/clean/word_count_PUBDATEGR.tsv (for all publishing date groups)
- Creates: 
    - data/intermediates/pubdategr_topics.tsv 
    - data/intermediates/top_words_for_topics.tsv 
    - data/intermediates/top_PMID_for_topics.tsv 

To run independently, input into terminal
```
Rscript code/04-topic-modelling.R
```

## 05-inspect-topics.R

Plots the top words and extracts the top articles from each topic.

- Requires: data/intermediates/top_words_for_topics.tsv
- Output: 
    - results/topic_info.png 
    - results/topic_info2.txt 

To run independently, input into terminal
```
Rscript code/05-inspect-topics.R
```

## 06-plot-topic-trends.R

Creates a line plot of how topics changed over time.

- Requires: data/intermediates/pubdategr_topics.tsv
- Creates: results/trends_plot.png

To run independently, input into terminal
```
Rscript code/06-plot-topic-trends.R
```
