## Clean the data
## 
## Requires:
##  - data/clean/antimicrobial_resistance_no_abstract.tsv
##  - data/clean/antimicrobial_resistance_abstract.tsv
## Creates: 
## - data/clean/antimicrobial_resistance_clean.tsv


# load libraries
library(tidyverse)

# read in article data
article_data <- readr::read_tsv("data/clean/antimicrobial_resistance_no_abstract.tsv")
abstract_data <- readr::read_tsv("data/clean/antimicrobial_resistance_abstract.tsv")

# seperate PMID and abstract columns 
abstract_data <- tidyr::separate(abstract_data, `PMID|Abstract`, into = c("PMID", "Abstract"), sep = "\\|")

# combine the abstract data with the rest of the artical information
article_data <- article_data |> 
    mutate(PMID = as.character(PMID)) |> 
    left_join(abstract_data, by="PMID")

# remove [] and ' from the titles
article_data <- article_data |> 
    mutate(Title = str_remove_all(Title, "\\[|\\]|'"))

# save cleaned data as a new tsv
readr::write_tsv(article_data, "data/clean/antimicrobial_resistance_clean.tsv")

cat("Data cleaned.")