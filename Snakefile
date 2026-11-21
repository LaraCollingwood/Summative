# -*- mode: snakemake -*-
configfile: "config.yml"

rule all:
 input:
    expand("results/articles_per_year_plot_{decade}.png", decade=config["decade"])

rule setup:
    "create all directories"
    shell:
        """
        mkdir -p logs
        mkdir -p data/raw
        mkdir -p data/clean
        mkdir -p results
        """
# Running code scripts -----------------------------------------------------------------

rule download_data:
    input:
        "code/01-download-data.sh",
    output:
        "data/raw/pubmed_data_{decade}.xml",
        #"logs/01-download-data.txt"
    shell:
        """
        mkdir -p logs
        mkdir -p data/raw
        bash code/01-download-data.sh {wildcards.decade} #> logs/01-download-data.txt
        """

rule convert_data_format:
    input:
        "code/02-convert-data-format.sh",
        "data/raw/pubmed_data_{decade}.xml"
    output:
        "data/clean/pubmed_data_no_abstract_{decade}.tsv",
        "data/clean/pubmed_data_abstract_{decade}.tsv",
        #"logs/02-convert-data-format.txt"
    shell:
        """
        mkdir -p data/clean
        bash code/02-convert-data-format.sh {wildcards.decade} #> logs/02-convert-data-format.txt
        """

rule simple_clean_data:
    input:
        "code/03-simple-clean-data.R",
        "data/clean/pubmed_data_no_abstract_{decade}.tsv",
        "data/clean/pubmed_data_abstract_{decade}.tsv"
    output:
        "data/clean/pubmed_data_clean_{decade}.tsv",
        #"logs/03-simple-clean-data.txt"
    shell:
        """
        Rscript code/03-simple-clean-data.R {wildcards.decade} #> logs/03-simple-clean-data.txt
        """

rule simple_process_data:
    input:
        "code/04-simple-process-data.R",
        "data/clean/pubmed_data_clean_{decade}.tsv"
    output:
        "data/clean/articles_per_year_{decade}.tsv",
        #"logs/04-simple-process-data.txt"
    shell:
        """
        Rscript code/04-simple-process-data.R {wildcards.decade} #> logs/04-simple-process-data.txt
        """

rule simple_plot_data:
    input:
        "code/05-simple-plot-data.R",
        "data/clean/articles_per_year_{decade}.tsv"
    output:
        "results/articles_per_year_plot_{decade}.png",
        #"logs/05-simple-plot-data.txt"
    shell:
        """
        Rscript code/05-simple-plot-data.R {wildcards.decade} #> logs/05-simple-plot-data.txt
        """

# Cleaning ---------------------------------------------------------------------------

rule cleanup_partial:
    "Remove all files except raw data"
    shell: 
        """
        if [ -d logs ]; then
        rm -r logs
        else
        echo directory logs does not exist
        fi

        if [ -d data/clean ]; then
        rm -r data/clean
        else
        echo directory data/clean does not exist
        fi

        if [ -d results ]; then
        rm -r results
        else
        echo directory results does not exist
        fi
        """

rule cleanup_full:
    "Remove all files, including raw data"
    shell: 
        """
        if [ -d logs ]; then
        rm -r logs
        else
        echo directory logs does not exist
        fi

        if [ -d data/raw ]; then
        rm -r data/raw
        else
        echo directory data/raw does not exist
        fi

        if [ -d data/clean ]; then
        rm -r data/clean
        else
        echo directory data/clean does not exist
        fi

        if [ -d results ]; then
        rm -r results
        else
        echo directory results does not exist
        fi
        """