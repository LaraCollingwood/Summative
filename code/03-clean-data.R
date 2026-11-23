## Convert abstract data into word counts
##
## Input: PUBDATEGR variable
## Requires: data/clean/abstracts.tsv
## Creates: data/clean/word_count.tsv


library(tidyverse)
library(tidytext)

# define arguments
args = 	commandArgs(trailingOnly = TRUE)
PUBDATEGR = args[1]

# read in article data
abstract_data <- readr::read_tsv(paste0("data/clean/abstracts_",PUBDATEGR,".tsv"))

 # Clean up --------------------------------------------------------------------------

abstract_data <- abstract_data |>
    # seperate PMID and abstract columns    
    tidyr::separate(`PMID|Abstract`, into = c("PMID", "Abstract"), sep = "\\|") |>
    # remove articles without an abstract
    filter(!is.na(Abstract)) |>
    # add PubDateGr column
    mutate(PubDateGr = PUBDATEGR)

 # Count frequency of each word --------------------------------------------------------------------------

# These words are commonly used throughout all research, and so will not be included in topic modelling
common_words <- tibble(word=c(

    # General academic terminology
    "found", "observed", "reported",
    "including", "compared", "determined",
    "revealed", "demonstrated", "significant",
    "significantly", "based", "obtained",
    "performed", "investigated", "suggest",
    "similar", "addition", "total",
    "potential", "specific", "common",
    "major", "highly", "single",
    "multiple", "different", "related",
    "due", "time", "period", "increased",

    # Generic research terminology
    "study", "studies", "result", "results",
    "method", "methods", "analysis",
    "data", "sample", "samples",
    "identified", "detected", "collected",
    "tested", "test", "testing",
    "isolate","isolates","isolated",
    "health", "effect", "ci", "confidence", 
    "interval",

    # General AMR terminology
    "antimicrobial", "antimicrobials",
    "resistance", "resistant", "amr",
    "antibiotic", "antibiotics",
    "antibacterial",

    # E. coli terminology
    "escherichia", "coli", "bacteria",
    "bacterial", "bacterium", "strain",
    "strains",

    "gene","genes","plasmid","plasmids"
))

word_count <- abstract_data |> 
    unnest_tokens(word, Abstract) |> 
    filter(!str_detect(word, "[0-9]")) |>
    anti_join(stop_words) |> 
    anti_join(common_words) |> 
    count(PMID, PubDateGr, word, sort=TRUE)



# save cleaned data as a new tsv ---------------------------------------------------------------------------

readr::write_tsv(word_count, paste0("data/clean/word_count_",PUBDATEGR,".tsv"))