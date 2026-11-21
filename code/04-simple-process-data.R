## Create a file of the number of articles per year
##
## Requires: data/clean/pubmed_data_clean.tsv
## Creates: data/clean/articles_per_year.tsv

# define arguments
args = 	commandArgs(trailingOnly = TRUE)
decade = args[1]

# load libraries
library(tidyverse)

# read in article data
article_data <- readr::read_tsv(paste0("data/clean/pubmed_data_clean_",decade,".tsv"))

# create table of articles written per year
articles_per_year <- article_data |> 
    filter(!is.na(YearPublished)) |> 
    group_by(YearPublished) |> 
    summarise(n=n())

# save results
readr::write_tsv(articles_per_year, paste0("data/clean/articles_per_year_",decade,".tsv"))

cat("Data processed.")
cat(paste0("Decade: ",decade))