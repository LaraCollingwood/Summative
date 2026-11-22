## plot the top words from each topic
##
## Requires: data/clean/top_words_for_topics.tsv
## Output: results/topic_info.png

library(tidyverse)
library(tidytext)

top_words_for_topics <- readr::read_tsv("data/clean/top_words_for_topics.tsv")

top_words_for_topics |> 
    ggplot(aes(x=beta, y=reorder_within(term,beta,topic), fill=topic)) +
    facet_wrap(~topic, scales="free_y") +
    geom_col(show.legend=FALSE) +
    scale_y_reordered() +
    labs(x="count", y="") +
    ggtitle("Top words in each topic")

 # save plot
 # save plot
ggsave("results/topic_info.png")   