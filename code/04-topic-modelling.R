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
dtm_matrix <- word_count_all |> cast_dtm(Decade, word, n)

# Create a LDA topic model
LDA_topic_model <- LDA(dtm_matrix, k=3, control=list(seed=123))

# For each decade, see how well it fits into each topic
decade_topics <- tidy(LDA_topic_model, matrix="gamma") |>
    mutate(
        topic = as.factor(topic),
        Decade = document,
        Decade_label = paste0(document,"s")
    ) 


# Get info on the topics ---------------------------------------------

# For each word, see how well it fits into each topic
word_topics <- tidy(LDA_topic_model, matrix="beta") 

word_topics |> 
  group_by(topic) |> 
  slice_max(order_by=beta, n=10)

  
# Save as file --------------------------------------------

readr::write_tsv(decade_topics, "data/clean/decade_topics.tsv")