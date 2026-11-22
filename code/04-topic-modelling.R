## Topic modelling

## Requires: all word counts
## Creates: LDA output

library(tidyverse)
library(tidytext)
library(topicmodels)
library(reshape2)

# Combine all word counts
files <- list.files(path = "data/clean/",pattern = "^word_count_.*\\.tsv$",full.names = TRUE)
word_count_all <- map_dfr(files, read_tsv)

# Creating the model -------------------------------------------------

# Turn the word counts into a matrix
dtm_matrix <- word_count_all |> cast_dtm(PubDateGr, word, n)

# Create a LDA topic model
LDA_topic_model <- LDA(dtm_matrix, k=3, control=list(seed=123))

# For each publishing date group, see how well it fits into each topic
pubdategr_topics <- tidy(LDA_topic_model, matrix="gamma") |>
    mutate(
        topic = as.factor(topic),
        PubDateGr = document,
        PubDateGr_label = paste0(document,"-",as.numeric(document)+4)
    ) 


# Get info on the topics ---------------------------------------------

# For each word, see how well it fits into each topic
word_topics <- tidy(LDA_topic_model, matrix="beta") 

top_words_for_topics <- word_topics |> 
  group_by(topic) |> 
  slice_max(order_by=beta, n=10)

  
# Save as file --------------------------------------------

readr::write_tsv(pubdategr_topics, "data/clean/pubdategr_topics.tsv")
readr::write_tsv(top_words_for_topics, "data/clean/top_words_for_topics.tsv")