## Create a file of the number of articles per year
##
## Requires: data/clean/antimicrobial_resistance_clean.tsv
## Creates: data/clean/articles_per_year.tsv

# load libraries
library(tidyverse)

# read in article data
article_data <- readr::read_tsv("data/clean/antimicrobial_resistance_clean.tsv")

# create table of articles written per year
articles_per_year <- article_data |> 
    filter(!is.na(YearPublished)) |> 
    group_by(YearPublished) |> 
    summarise(n=n())

# save results
readr::write_tsv(articles_per_year, "data/clean/articles_per_year.tsv")