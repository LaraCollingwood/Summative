## Clean the data
## 
## Requires:
##  - data/clean/pubmed_data_no_abstract.tsv
##  - data/clean/pubmed_data_abstract.tsv
## Creates: 
## - data/clean/pubmed_data_clean.tsv
## - data/clean/pubmed_data_clean.tsv
## - data/clean/mesh_data_clean.tsv

# load libraries
library(tidyverse)

# read in article data
article_data <- readr::read_tsv("data/clean/pubmed_data_no_abstract.tsv")
abstract_data <- readr::read_tsv("data/clean/pubmed_data_abstract.tsv")
mesh_data <- readr::read_tsv("data/clean/pubmed_data_mesh_headings.tsv")

# Create article data -------------------------------------------------------------------------------------

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
readr::write_tsv(article_data, "data/clean/pubmed_data_clean.tsv")

# Create mesh data -------------------------------------------------------------------------------------

# Seperate out Desctiptor and quantifier
mesh_data <- mesh_data |> 
  tidyr::separate_rows(Mesh, sep = "\\|") |> 
  separate(Mesh, into = c("MeshDescriptor", "MeshQualifier"), sep = ";", fill = "right")

# save cleaned data at new file
readr::write_tsv(mesh_data, "data/clean/mesh_data_clean.tsv")

cat("Data cleaned.")