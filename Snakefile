# -*- mode: snakemake -*-
configfile: "config.yml"

rule all:
 input:
    "results/trends_plot.png",
    "results/topic_info.png"

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
        "code/01-download-data.sh"
    output:
        ensure("data/raw/pubmed_data_{PubDateGr}.xml", non_empty=True)
    resources:
        download_slots=1
    retries: 3
    shell:
        """
        mkdir -p logs
        mkdir -p data/raw
        bash code/01-download-data.sh {wildcards.PubDateGr} true > logs/download_log_{wildcards.PubDateGr}.txt
        """

rule convert_data_format:
    input:
        "code/02-convert-data-format.sh",
        "data/raw/pubmed_data_{PubDateGr}.xml"
    output:
        "data/clean/abstracts_{PubDateGr}.tsv",
        #"logs/02-convert-data-format.txt"
    shell:
        """
        mkdir -p data/clean
        bash code/02-convert-data-format.sh {wildcards.PubDateGr} #> logs/02-convert-data-format.txt
        """

rule clean_data:
    input:
        "code/03-clean-data.R",
        "data/clean/abstracts_{PubDateGr}.tsv"
    output:
        "data/clean/word_count_{PubDateGr}.tsv"
    shell:
        """
        Rscript code/03-clean-data.R {wildcards.PubDateGr} 
        """

rule topic_modelling:
    input:
        "code/04-topic-modelling.R",
        expand("data/clean/word_count_{PubDateGr}.tsv", PubDateGr=config["PUBDATEGR"])
    output:
        "data/intermediates/pubdategr_topics.tsv",
        "data/intermediates/top_words_for_topics.tsv"
    shell:
        """
        mkdir -p data/intermediates
        Rscript code/04-topic-modelling.R
        """

rule inspect_topics:
    input:
        "code/05-inspect-topics.R",
        "data/intermediates/top_words_for_topics.tsv"
    output:
        "results/topic_info.png"
    shell:
        """
        Rscript code/05-inspect-topics.R
        """

rule plot_topic_trends:
    input:
        "code/06-plot-topic-trends.R",
        "data/intermediates/pubdategr_topics.tsv"
    output:
        "results/trends_plot.png"
    shell:
        """
        Rscript code/06-plot-topic-trends.R
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

        if [ -d data/intermediates ]; then
        rm -r data/intermediates
        else
        echo directory data/intermediates does not exist
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

        if [ -d data/intermediates ]; then
        rm -r data/intermediates
        else
        echo directory data/intermediates does not exist
        fi

        if [ -d results ]; then
        rm -r results
        else
        echo directory results does not exist
        fi
        """