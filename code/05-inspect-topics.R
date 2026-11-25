## Plot the top words from each topic
##
## Requires: data/intermediates/top_words_for_topics.tsv
## Output: 
## - results/topic_info.png
## - results/topic_info2.txt

library(tidyverse)
library(tidytext)

# Prevent Rplots.pdf from being generated
pdf(NULL) 

# Inspecting top words ----------------------------------------------------------------------

# Read in the data
top_words_for_topics <- readr::read_tsv("data/intermediates/top_words_for_topics.tsv")

# Add labels to topics
top_words_for_topics <- top_words_for_topics |> 
    mutate(topic_label = case_when(
        topic==1 ~ "1: Livestock",
        topic==2 ~ "2: Biological\nmechanisms",
        topic==3 ~ "3: Water and\nthe environment",
        topic==4 ~ "4: Genomics",
        topic==5 ~ "5: Resistance\ngene detection",
        topic==6 ~ "6: Patients",   
))

# Define colour palette
colour_palette = c("#FF1F3DFF","#1F6BFFFF","#00D45AFF","#FFB000FF","#B200FFFF","#00D1E0FF")

# Plot a horizontal bar graph for each topic, showing the top 20 words
top_words_for_topics |> 
    ggplot(aes(x=beta, y=reorder_within(term,beta,topic_label), fill=topic_label)) +
    facet_wrap(~topic_label, scales="free_y") +
    geom_col(show.legend=FALSE) +
    scale_y_reordered() +
    labs(x="Word-topic probability", y="",
         title="Top Words in Each Topic") +
    scale_fill_manual(values = colour_palette) +
    theme_minimal() +
    theme(axis.text.x = element_blank()) 
top_words_for_topics

# Save the plot
ggsave("results/topic_info.png")   

# Inspecting top articles ------------------------------------------------------------------------

# Read in the data
top_PMID_for_topics <- readr::read_tsv("data/intermediates/top_PMID_for_topics.tsv")

# Combine all abstracts 
files2 <- list.files(path = "data/clean/",pattern = "^abstracts_.*\\.tsv$",full.names = TRUE)
abstracts_all <- map_dfr(files2, read_tsv, show_col_types = FALSE)
abstracts_all <- abstracts_all |>
    tidyr::separate(`PMID|Abstract`, into = c("PMID", "Abstract"), sep = "\\|") |>
    mutate(PMID=as.double(PMID))

# Combine the abstracts with the top articles
top_PMID_for_topics <- left_join(top_PMID_for_topics,abstracts_all) |> 
    unique()


writeLines("TOP ARTICLES\n ", "results/topic_info2.txt")

for (topicnum in 1:6){
    # Print a title for each topic
    cat(paste0("Topic: ",topicnum," ===========================\n\n"), file = "results/topic_info2.txt", append = TRUE)
  
    # Filter the PMID list for this topic
    top_PMID <- top_PMID_for_topics |> filter(topic==topicnum)
  
    for (abstractnum in 1:10){
        # Print individual abstract
        cat(top_PMID$Abstract[abstractnum], file = "results/topic_info2.txt", append = TRUE)
        cat("\n\n", file = "results/topic_info2.txt", append = TRUE)
    }
}