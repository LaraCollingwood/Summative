## plot the top words from each topic
##
## Requires: data/clean/top_words_for_topics.tsv
## Output: results/topic_info.png

library(tidyverse)
library(tidytext)

# prevent Rplots.pdf from being generated
pdf(NULL) 

top_words_for_topics <- readr::read_tsv("data/clean/top_words_for_topics.tsv")

# Add labels to topics
top_words_for_topics <- top_words_for_topics |> 
    mutate(topic_label = case_when(
        topic==1 ~ "1: label",
        topic==2 ~ "2: label",
        topic==3 ~ "3: label",
        topic==4 ~ "4: label",
        topic==5 ~ "5: label",
        topic==6 ~ "6: label",
        
    ))

# Define colour palette
colour_palette = c("#D72000FF","#EE6100FF","#FFAD0AFF","#1BB6AFFF","#9093A2FF","#132157FF")

#Plot
top_words_for_topics |> 
    ggplot(aes(x=beta, y=reorder_within(term,beta,topic_label), fill=topic_label)) +
    facet_wrap(~topic_label, scales="free_y") +
    geom_col(show.legend=FALSE) +
    scale_y_reordered() +
    labs(x="Word-topic probability", y="",
         title="Top Words in Each Topic") +
    scale_fill_manual(values = colour_palette) +
    theme_minimal()
top_words_for_topics

 # save plot

ggsave("results/topic_info.png")   