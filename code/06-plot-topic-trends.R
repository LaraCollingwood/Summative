## Create line plot of trends
##
## Requires: data/clean/pubdategr_topics.tsv
## Creates: results/trends_plot.png

library(tidyverse)

# prevent Rplots.pdf from being generated
pdf(NULL) 

# Read in data
pubdategr_topics <- readr::read_tsv("data/clean/pubdategr_topics.tsv")

# Plot
pubdategr_topics |>
    ggplot(aes(x=PubDateGr, y=gamma, colour=as.factor(topic))) +
    geom_line() +
    geom_point() +
    scale_x_continuous(
        breaks = sort(unique(pubdategr_topics$PubDateGr)),
        labels = sort(unique(pubdategr_topics$PubDateGr_label))
    ) +
    labs(
        title="Changes in Research Topics in AMR",
        y="Proportion of text assosiated with each topic",
        colour="Topic"
    ) +
    theme_minimal()

# save plot
ggsave("results/trends_plot.png") 