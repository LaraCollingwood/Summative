## Uses Latent Dirichlet Allocation to pick out 6 key topics, 
## then see how well the articles from each publishing data group fit into these topics.
##
## Requires: data/clean/word_count_PUBDATEGR.tsv (for all publishing date groups)
## Creates: 
## - data/intermediates/pubdategr_topics.tsv
## - data/intermediates/top_words_for_topics.tsv

library(tidyverse)
library(tidytext)
library(topicmodels)
library(reshape2)


# Get word count data ---------------------------------------------------------------------------------

# Combine all word counts
files <- list.files(path = "data/clean/",pattern = "^word_count_.*\\.tsv$",full.names = TRUE)
word_count_all <- map_dfr(files, read_tsv, show_col_types = FALSE)

# Create a look up file containing the PubDateGr for each PMID
PMID_pubdategr_id <- word_count_all |> 
    select(PMID, PubDateGr) |> 
    mutate(PMID = as.character(PMID)) |> 
    unique()


# Creating the model ---------------------------------------------------------------------------------

# Turn the word counts into a matrix
dtm_matrix <- word_count_all |> cast_dtm(PMID, word, n)

# Create a LDA topic model
LDA_topic_model <- LDA(dtm_matrix, k=6, control=list(seed=123))

# For each abstract, see how well it fits into each topic
PMID_topics <- tidy(LDA_topic_model, matrix="gamma") |>
    mutate(
        topic = as.factor(topic),
        PMID = document
    ) 

# Add a PubDateGr column and find the mean gamma of each publishing date group
pubdategr_topics <- left_join(PMID_topics, PMID_pubdategr_id) |>
    group_by(PubDateGr, topic) |>
    summarise(gamma = mean(gamma)) |>
    mutate(PubDateGr_label = paste0(PubDateGr,"-",as.numeric(PubDateGr)+4))


# Get info on the topics -----------------------------------------------------------

# For each word, see how well it fits into each topic
word_topics <- tidy(LDA_topic_model, matrix="beta") 

# Isolate the top words from each topic
top_words_for_topics <- word_topics |> 
    group_by(topic) |> 
    slice_max(order_by=beta, n=20)

# Isolate top articles fro each topic  
top_PMID_for_topics <- PMID_topics |> 
    group_by(topic) |> 
    slice_max(order_by=gamma, n=10)
  
# Save data as files ---------------------------------------------------------------------

readr::write_tsv(pubdategr_topics, "data/intermediates/pubdategr_topics.tsv")

readr::write_tsv(top_words_for_topics, "data/intermediates/top_words_for_topics.tsv")
readr::write_tsv(top_PMID_for_topics, "data/intermediates/top_PMID_for_topics.tsv")