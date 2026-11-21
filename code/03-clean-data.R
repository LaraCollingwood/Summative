## Clean the data
## 
## Requires:
##  - data/clean/pubmed_data_no_abstract.tsv
##  - data/clean/pubmed_data_abstract.tsv
## Creates: 
## - data/clean/pubmed_data_clean.tsv
## - data/clean/pubmed_data_clean.tsv


# define arguments
args = 	commandArgs(trailingOnly = TRUE)
decade = args[1]

# load libraries
library(tidyverse)

# read in article data
article_data <- readr::read_tsv(paste0("data/clean/pubmed_data_no_abstract_",decade,".tsv"))
abstract_data <- readr::read_tsv(paste0("data/clean/pubmed_data_abstract_",decade,".tsv"))

# Create article data -------------------------------------------------------------------------------------

# seperate PMID and abstract columns 
abstract_data <- tidyr::separate(abstract_data, `PMID|Abstract`, into = c("PMID", "Abstract"), sep = "\\|")

# combine the abstract data with the rest of the artical information
article_data <- article_data |> 
    mutate(PMID = as.character(PMID)) |> 
    left_join(abstract_data, by="PMID")


article_data <- article_data |> 
    mutate(
        # remove [] and ' from the titles
        Title = str_remove_all(Title, "\\[|\\]|'"),
        # create decade column
        Decade = paste0( substr( as.character(YearPublished), 1,3), "0s"))

# save cleaned data as a new tsv
readr::write_tsv(article_data, paste0("data/clean/pubmed_data_clean_",decade,".tsv"))



cat("Data cleaned.")
cat(paste0("Decade: ",decade))